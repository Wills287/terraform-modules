module "nat_metadata" {
  source = "git::https://github.com/Wills287/terraform-modules//aws/general/metadata?ref=v0.0.5"

  enabled = var.enabled
  namespace = var.namespace
  environment = var.environment
  name = var.name
  service = var.service
  delimiter = var.delimiter
  attributes = compact(concat(var.attributes, [
    "nat"]
  ))
  tags = var.tags
}

locals {
  ngw_count = var.enabled && var.nat_gateway_enabled ? length(var.availability_zones) : 0
}

resource "aws_eip" "default" {
  count = local.ngw_count
  vpc = true

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

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "default" {
  count = local.ngw_count
  allocation_id = element(aws_eip.default.*.id, count.index)
  subnet_id = element(aws_subnet.public.*.id, count.index)

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

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route" "default" {
  count = local.ngw_count
  route_table_id = element(aws_route_table.private.*.id, count.index)
  nat_gateway_id = element(aws_nat_gateway.default.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  depends_on = [
    aws_route_table.private
  ]
}
