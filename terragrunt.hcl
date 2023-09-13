locals {
  global  = yamldecode(file(find_in_parent_folders("global_vars.yaml")))
  tier = yamldecode(file(find_in_parent_folders("tier_vars.yaml")))
}

remote_state {
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket         = local.tier.backend.s3.bucket_name
    key            = "${local.global.owner}/${path_relative_to_include()}/terraform.tfstate"
    region         = local.tier.backend.s3.region
    encrypt        = true
    dynamodb_table = local.tier.backend.s3.dynamodb_table
    role_arn       = local.tier.backend.s3.role_arn
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::${local.tier.aws.account_id}:role/gitlab-runner"
  }
}
EOF
}

generate "default_tags" {
  path      = "default_tags.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
locals {
  default_tags = {
    Owner       = "${local.global.owner}"
    Maintainer  = "${local.global.maintainer}"
    ManagedBy   = "Terragrunt"
    Environment = "${split("/", path_relative_to_include())[0]}"
    Service     = "${split("/", path_relative_to_include())[1]}"
  }
}
EOF
}
