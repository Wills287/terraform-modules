output "url" {
  description = "The url for the created queue"
  value = aws_sqs_queue.this.id
}

output "arn" {
  description = "The ARN of the created queue"
  value = aws_sqs_queue.this.arn
}
