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

resource "aws_alb_target_group" "this" {
  name                 = "${module.metadata.id}-tg"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = var.deregistration_delay

  tags = module.metadata.tags
}

resource "aws_alb" "this" {
  name            = module.metadata.id
  subnets         = var.public_subnet_ids
  security_groups = ["${aws_security_group.this.id}"]

  tags = module.metadata.tags
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.this.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.this.arn
    type             = "forward"
  }
}

resource "aws_security_group" "this" {
  name   = "${module.metadata.name}-alb-sg"
  vpc_id = var.vpc_id

  tags = module.metadata.tags
}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = var.allow_cidr_block
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}
