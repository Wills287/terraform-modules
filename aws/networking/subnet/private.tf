module "private_metadata" {
  source = "git::https://github.com/Wills287/terraform-modules//aws/general/metadata?ref=v0.0.5"

  enabled = var.enabled
  namespace = var.namespace
  environment = var.environment
  name = var.name
  service = var.service
  delimiter = var.delimiter
  attributes = compact(concat(var.attributes, [
    "private"]
  ))
  tags = var.tags
}

locals {
  private_type = "Private"
  private_count = var.enabled ? var.max_subnet_count == 0 ? length(data.aws_availability_zones.azs.names) : var.max_subnet_count : 0
}

resource "aws_subnet" "private" {
  count = local.private_count
  vpc_id = var.vpc_id
  availability_zone = element(var.availability_zones, count.index)
  cidr_block = cidrsubnet(var.cidr_block, ceil(log(local.private_count, 2)), count.index)

  tags = merge(module.private_metadata.tags, {
    "Name" = format(
    "%s%s%s",
    module.private_metadata.id,
    var.delimiter,
    replace(element(var.availability_zones, count.index), "-", var.delimiter)
    )
    "AZ" = element(var.availability_zones, count.index)
    "Type" = local.private_type
  })
}

resource "aws_network_acl" "private" {
  count = var.enabled ? 1 : 0
  vpc_id = var.vpc_id
  subnet_ids = aws_subnet.private.*.id
  dynamic "egress" {
    for_each = var.private_network_acl_egress
    content {
      action = lookup(egress.value, "action", null)
      cidr_block = lookup(egress.value, "cidr_block", null)
      from_port = lookup(egress.value, "from_port", null)
      icmp_code = lookup(egress.value, "icmp_code", null)
      icmp_type = lookup(egress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(egress.value, "ipv6_cidr_block", null)
      protocol = lookup(egress.value, "protocol", null)
      rule_no = lookup(egress.value, "rule_no", null)
      to_port = lookup(egress.value, "to_port", null)
    }
  }
  dynamic "ingress" {
    for_each = var.private_network_acl_ingress
    content {
      action = lookup(ingress.value, "action", null)
      cidr_block = lookup(ingress.value, "cidr_block", null)
      from_port = lookup(ingress.value, "from_port", null)
      icmp_code = lookup(ingress.value, "icmp_code", null)
      icmp_type = lookup(ingress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(ingress.value, "ipv6_cidr_block", null)
      protocol = lookup(ingress.value, "protocol", null)
      rule_no = lookup(ingress.value, "rule_no", null)
      to_port = lookup(ingress.value, "to_port", null)
    }
  }
  tags = module.private_metadata.tags
  depends_on = [
    aws_subnet.private
  ]
}

resource "aws_route_table" "private" {
  count = local.private_count
  vpc_id = var.vpc_id

  tags = merge(module.private_metadata.tags, {
    "Name" = format(
    "%s%s%s",
    module.private_metadata.id,
    var.delimiter,
    replace(element(var.availability_zones, count.index), "-", var.delimiter)
    )
    "AZ" = element(var.availability_zones, count.index)
    "Type" = local.private_type
  })
}

resource "aws_route_table_association" "private" {
  count = local.private_count
  subnet_id = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
  depends_on = [
    aws_subnet.private,
    aws_route_table.private,
  ]
}
