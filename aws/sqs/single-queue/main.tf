terraform {
  required_version = ">= 0.12"
}

resource "aws_sqs_queue" "this" {
  name = var.name
  max_message_size = var.max_message_size
  visibility_timeout_seconds = var.visibility_timeout
  message_retention_seconds = var.message_retention
  delay_seconds = var.delay
  receive_wait_time_seconds = var.receive_wait_time

  tags = var.tags
}
