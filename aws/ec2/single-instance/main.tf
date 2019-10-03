terraform {
  required_version = ">= 0.12"
}

resource "aws_instance" "this" {
  ami = var.ami[var.region]
  instance_type = var.instance_type
  vpc_security_group_ids = [
    aws_security_group.this.id
  ]

  user_data = <<-DATA
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd _f _p "${var.server_port}" &
              DATA

  tags = var.tags
}

resource "aws_security_group" "this" {
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
