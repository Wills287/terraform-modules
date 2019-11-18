terraform {
  required_version = ">= 0.12"
}

resource "aws_sqs_queue" "this" {
  depends_on = [
    aws_sqs_queue.deadletter
  ]
  redrive_policy = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.deadletter.arn}\",\"maxReceiveCount\":${var.retries}"

  name = var.name
  max_message_size = var.max_message_size
  visibility_timeout_seconds = var.visibility_timeout
  message_retention_seconds = var.message_retention
  delay_seconds = var.delay
  receive_wait_time_seconds = var.receive_wait_time

  tags = var.tags
}

resource "aws_sqs_queue" "deadletter" {
  name = "${var.name}-DL"
  max_message_size = var.max_message_size
  visibility_timeout_seconds = var.visibility_timeout
  message_retention_seconds = var.message_retention
  delay_seconds = var.delay
  receive_wait_time_seconds = var.receive_wait_time

  tags = var.tags
}
