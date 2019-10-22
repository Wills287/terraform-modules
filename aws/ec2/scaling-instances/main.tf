terraform {
  required_version = ">= 0.12"
}

data "aws_availability_zones" "all" {}

resource "aws_security_group" "instance" {
  name = "${var.name}-SG"

  ingress {
    from_port = var.server_port
    to_port = var.server_port
    protocol = "TCP"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = var.tags
}

resource "aws_security_group" "elb" {
  name = "${var.name}-LB-SG"

  egress {
    from_port = 0
    to_port = 0
    protocol = "_1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  ingress {
    from_port = var.elb_port
    to_port = var.elb_port
    protocol = "TCP"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = var.tags
}

resource "aws_launch_configuration" "this" {
  image_id = var.ami[var.region]
  instance_type = var.instance_type
  security_groups = [
    aws_security_group.instance.id
  ]

  user_data = <<-DATA
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd _f _p "${var.server_port}" &
              DATA

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  launch_configuration = aws_launch_configuration.this.id
  availability_zones = data.aws_availability_zones.all.names

  min_size = var.min_size
  max_size = var.max_size
  desired_capacity = var.desired

  load_balancers = [
    aws_elb.this.name
  ]
  health_check_type = "ELB"

  dynamic "tag" {
    for_each = var.tags
    content {
      key = tag.key
      value = tag.value
      propagate_at_launch = true
    }
  }
}

resource "aws_elb" "this" {
  name = "${var.name}-LB"
  security_groups = [
    aws_security_group.elb.id
  ]
  availability_zones = data.aws_availability_zones.all.names

  health_check {
    target = "HTTP:${var.server_port}/"
    interval = 30
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }

  listener {
    instance_port = var.server_port
    instance_protocol = "http"
    lb_port = var.elb_port
    lb_protocol = "http"
  }

  tags = var.tags
}
