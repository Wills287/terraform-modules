module "public_metadata" {
  source = "git::https://github.com/Wills287/terraform-modules//aws/general/metadata?ref=v0.0.5"

  enabled = var.enabled
  namespace = var.namespace
  environment = var.environment
  name = var.name
  service = var.service
  delimiter = var.delimiter
  attributes = compact(concat(var.attributes, [
    "public"]
  ))
  tags = var.tags
}

locals {
  public_type = "Public"
  public_count = var.enabled ? length(var.availability_zones) : 0
}

resource "aws_subnet" "public" {
  count = local.public_count
  vpc_id = var.vpc_id
  availability_zone = element(var.availability_zones, count.index)
  cidr_block = cidrsubnet(var.cidr_block, ceil(log(local.public_count, 2)), count.index)
  map_public_ip_on_launch = var.public_map_public_ip

  tags = merge(module.public_metadata.tags, {
    "Name" = format(
    "%s%s%s",
    module.public_metadata.id,
    var.delimiter,
    replace(element(var.availability_zones, count.index), "-", var.delimiter)
    )
    "AZ" = element(var.availability_zones, count.index)
    "Type" = local.public_type
  })
}

resource "aws_network_acl" "public" {
  count = var.enabled ? 1 : 0
  vpc_id = var.vpc_id
  subnet_ids = aws_subnet.public.*.id
  dynamic "egress" {
    for_each = var.public_network_acl_egress
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
    for_each = var.public_network_acl_ingress
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
  tags = module.public_metadata.tags
  depends_on = [
    aws_subnet.public
  ]
}

resource "aws_route_table" "public" {
  count = local.public_count
  vpc_id = var.vpc_id

  tags = merge(module.public_metadata.tags, {
    "Name" = format(
    "%s%s%s",
    module.public_metadata.id,
    var.delimiter,
    replace(element(var.availability_zones, count.index), "-", var.delimiter)
    )
    "AZ" = element(var.availability_zones, count.index)
    "Type" = local.public_type
  })
}

resource "aws_route" "public" {
  count = local.public_count
  route_table_id = element(aws_route_table.public.*.id, count.index)
  gateway_id = data.aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
  depends_on = [
    aws_route_table.public
  ]
}

resource "aws_route_table_association" "public" {
  count = local.public_count
  subnet_id = element(aws_subnet.public.*.id, count.index)
  route_table_id = element(aws_route_table.public.*.id, count.index)
  depends_on = [
    aws_subnet.public,
    aws_route_table.public,
  ]
}
