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

resource "aws_ecs_cluster" "this" {
  name = module.metadata.id
  tags = module.metadata.tags
}
