locals {
  name = "vpc-${var.owner}-${var.environment}"

  # The default subnet count is the length of azs
  default_subnet_count = length(var.azs)

  # Calculate CIDR block for each type of subnet
  database_cidr    = cidrsubnet(var.cidr, 4, 0)
  elasticache_cidr = cidrsubnet(var.cidr, 4, 1)
  public_cidr      = cidrsubnet(var.cidr, 4, 2)
  private_cidr     = cidrsubnet(var.cidr, 4, 3)
  redshift_cidr    = cidrsubnet(var.cidr, 4, 4)
  intra_cidr       = cidrsubnet(var.cidr, 4, 5)

  # Database subnets
  database_subnets_count   = var.overwrite_database_subnets_count ? var.database_subnets_count : local.default_subnet_count
  database_subnets_newbits = var.enable_database_subnets ? [for _ in range(local.database_subnets_count) : 4] : []
  database_subnets         = var.enable_database_subnets ? cidrsubnets(local.database_cidr, local.database_subnets_newbits...) : []

  # Elasticache subnets
  elasticache_subnets_count   = var.overwrite_elasticache_subnets_count ? var.elasticache_subnets_count : local.default_subnet_count
  elasticache_subnets_newbits = var.enable_elasticache_subnets ? [for _ in range(local.elasticache_subnets_count) : 4] : []
  elasticache_subnets         = var.enable_elasticache_subnets ? cidrsubnets(local.elasticache_cidr, local.elasticache_subnets_newbits...) : []

  # Public subnets
  public_subnets_count   = var.overwrite_public_subnets_count ? var.public_subnets_count : local.default_subnet_count
  public_subnets_newbits = var.enable_public_subnets ? [for _ in range(local.public_subnets_count) : 4] : []
  public_subnets         = var.enable_public_subnets ? cidrsubnets(local.public_cidr, local.public_subnets_newbits...) : []

  # Private subnets
  private_subnets_count   = var.overwrite_private_subnets_count ? var.private_subnets_count : local.default_subnet_count
  private_subnets_newbits = var.enable_private_subnets ? [for _ in range(local.private_subnets_count) : 4] : []
  private_subnets         = var.enable_private_subnets ? cidrsubnets(local.private_cidr, local.private_subnets_newbits...) : []

  # Redshift subnets
  redshift_subnets_count   = var.overwrite_redshift_subnets_count ? var.redshift_subnets_count : local.default_subnet_count
  redshift_subnets_newbits = var.enable_redshift_subnets ? [for _ in range(local.redshift_subnets_count) : 4] : []
  redshift_subnets         = var.enable_redshift_subnets ? cidrsubnets(local.redshift_cidr, local.redshift_subnets_newbits...) : []

  # Intra subnets
  intra_subnets_count   = var.overwrite_intra_subnets_count ? var.intra_subnets_count : local.default_subnet_count
  intra_subnets_newbits = var.enable_intra_subnets ? [for _ in range(local.intra_subnets_count) : 4] : []
  intra_subnets         = var.enable_intra_subnets ? cidrsubnets(local.intra_cidr, local.intra_subnets_newbits...) : []
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = local.name
  cidr = var.cidr

  azs = var.azs

  database_subnets    = local.database_subnets
  elasticache_subnets = local.elasticache_subnets
  public_subnets      = local.public_subnets
  private_subnets     = local.private_subnets
  redshift_subnets    = local.redshift_subnets
  intra_subnets       = local.intra_subnets

  enable_nat_gateway = var.enable_nat_gateway
  enable_vpn_gateway = var.enable_vpn_gateway

  tags = local.default_tags
}

variable "cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "owner" {
  type = string
}

variable "environment" {
  type = string
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "enable_vpn_gateway" {
  type    = bool
  default = false
}

variable "enable_database_subnets" {
  type    = bool
  default = false
}

variable "enable_elasticache_subnets" {
  type    = bool
  default = false
}

variable "enable_public_subnets" {
  type    = bool
  default = true
}

variable "enable_private_subnets" {
  type    = bool
  default = true
}

variable "enable_redshift_subnets" {
  type    = bool
  default = false
}

variable "enable_intra_subnets" {
  type    = bool
  default = false
}

variable "overwrite_database_subnets_count" {
  type    = bool
  default = false
}

variable "database_subnets_count" {
  type    = number
  default = null
}

variable "overwrite_elasticache_subnets_count" {
  type    = bool
  default = false
}

variable "elasticache_subnets_count" {
  type    = number
  default = null
}

variable "overwrite_public_subnets_count" {
  type    = bool
  default = false
}

variable "public_subnets_count" {
  type    = number
  default = null
}

variable "overwrite_private_subnets_count" {
  type    = bool
  default = false
}

variable "private_subnets_count" {
  type    = number
  default = null
}

variable "overwrite_redshift_subnets_count" {
  type    = bool
  default = false
}

variable "redshift_subnets_count" {
  type    = number
  default = null
}

variable "overwrite_intra_subnets_count" {
  type    = bool
  default = false
}

variable "intra_subnets_count" {
  type    = number
  default = null
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnet_ids" {
  value = module.vpc.private_subnets
}
