include "root" {
  path = find_in_parent_folders()
}

locals {
  global  = yamldecode(file(find_in_parent_folders("global_vars.yaml")))
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  owner = local.global.owner
  environment = split("/", path_relative_to_include())[0]
  subnet_id = dependency.vpc.outputs.private_subnet_ids[0]
}
