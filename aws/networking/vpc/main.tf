module "metadata" {
  source = "git::https://github.com/Wills287/terraform-modules//aws/general/metadata?ref=v0.0.11"

  enabled = var.enabled
  namespace = var.namespace
  environment = var.environment
  name = var.name
  service = var.service
  delimiter = var.delimiter
  attributes = var.attributes
  tags = var.tags
}

resource "aws_vpc" "this" {
  count = var.enabled ? 1 : 0

  cidr_block = var.cidr_block
  assign_generated_ipv6_cidr_block = var.assign_ipv6_cidr_block
  instance_tenancy = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_support
  enable_classiclink = var.enable_classiclink
  enable_classiclink_dns_support = var.enable_classiclink_dns_support

  tags = module.metadata.tags
}

resource "aws_default_security_group" "this" {
  count = var.enabled && var.override_default_security_group_rules ? 1 : 0

  vpc_id = aws_vpc.this.0.id

  tags = merge(module.metadata.tags, {
    Name = "Default Security Group"
  })
}

resource "aws_internet_gateway" "this" {
  count = var.enabled ? 1 : 0

  vpc_id = aws_vpc.this.0.id

  tags = module.metadata.tags
}
