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

resource "aws_launch_template" "this" {
  count = var.enabled ? 1 : 0

  name_prefix = format("%s%s", module.metadata.id, module.metadata.delimiter)

  disable_api_termination = var.disable_api_termination
  ebs_optimized           = var.ebs_optimized

  image_id                             = var.image_id
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior

  instance_type = var.instance_type
  key_name      = var.key_name

  user_data = var.user_data_base64

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  monitoring {
    enabled = var.enable_monitoring
  }

  network_interfaces {
    description                 = module.metadata.id
    device_index                = 0
    associate_public_ip_address = var.associate_public_ip_address
    delete_on_termination       = true
    security_groups             = var.security_group_ids
  }

  dynamic "tag_specifications" {
    for_each = var.tag_specifications_resource_types

    content {
      resource_type = tag_specifications.value
      tags          = module.metadata.tags
    }
  }

  tags = module.metadata.tags

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  launch_template_block = {
    id      = join("", aws_launch_template.this.*.id)
    version = var.launch_template_version != "" ? var.launch_template_version : join("", aws_launch_template.this.*.latest_version)
  }
  launch_template = (var.mixed_instances_policy == null ? local.launch_template_block : null)
  mixed_instances_policy = (
    var.mixed_instances_policy == null ? null : {
      instances_distribution = var.mixed_instances_policy.instances_distribution
      launch_template        = local.launch_template_block
      override               = var.mixed_instances_policy.override
  })
}

resource "aws_autoscaling_group" "this" {
  count = var.enabled ? 1 : 0

  name_prefix               = format("%s%s", module.metadata.id, module.metadata.delimiter)
  vpc_zone_identifier       = var.subnet_ids
  max_size                  = var.max_size
  min_size                  = var.min_size
  load_balancers            = var.load_balancers
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  min_elb_capacity          = var.min_elb_capacity
  wait_for_elb_capacity     = var.wait_for_elb_capacity
  target_group_arns         = var.target_group_arns
  default_cooldown          = var.default_cooldown
  force_delete              = var.force_delete
  termination_policies      = var.termination_policies
  suspended_processes       = var.suspended_processes
  placement_group           = var.placement_group
  enabled_metrics           = var.enabled_metrics
  metrics_granularity       = var.metrics_granularity
  wait_for_capacity_timeout = var.wait_for_capacity_timeout
  protect_from_scale_in     = var.protect_from_scale_in
  service_linked_role_arn   = var.service_linked_role_arn
  desired_capacity          = var.desired_capacity

  dynamic "launch_template" {
    for_each = (local.launch_template != null ?
    [local.launch_template] : [])
    content {
      id      = local.launch_template_block.id
      version = local.launch_template_block.version
    }
  }

  tags = flatten([
    for key in keys(module.metadata.tags) :
    {
      key                 = key
      value               = module.metadata.tags[key]
      propagate_at_launch = true
    }
  ])

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }
}
