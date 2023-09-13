include "root" {
  path = find_in_parent_folders()
}

locals {
  global = yamldecode(file(find_in_parent_folders("global_vars.yaml")))
}

inputs = {
  cidr = "10.0.0.0/16"
  owner = local.global.owner
  environment = split("/", path_relative_to_include())[0]
}
