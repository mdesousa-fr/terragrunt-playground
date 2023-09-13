locals {
  tags = {
    ProjectId = "p-123456"
    Namespace = "contoso"
    Tier = "standard"
  }
}

module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.5.0"

  name = "devops-test"

  instance_type = "t2.micro"
  subnet_id = var.subnet_id

  tags = merge(local.default_tags, local.tags)
}

variable "owner" {
  type = string
}

variable "environment" {
  type = string
}

variable "subnet_id" {
  type = string
}
