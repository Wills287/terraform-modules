module "metadata" {
  source = "git::https://github.com/Wills287/terraform-modules//aws/general/metadata?ref=v0.0.11"

  enabled     = var.enabled
  namespace   = var.namespace
  environment = var.environment
  name        = var.name
  service     = var.service
  delimiter   = var.delimiter
  attributes  = var.attributes
  tags        = var.tags
}

resource "aws_ecs_service" "this" {
  name            = module.metadata.id
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = var.desired_count
}

resource "aws_ecs_task_definition" "this" {
  family = module.metadata.id
  container_definitions = jsonencode([
    {
      name      = module.metadata.id
      image     = var.container_image
      cpu       = var.container_cpu
      memory    = var.container_memory
      essential = var.essential
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.host_port
        }
      ]
    }
  ])
}
