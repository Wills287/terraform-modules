output "ecs_cluster_id" {
  description = "The name of the cluster"
  value = join("", aws_ecs_cluster.this.*.id)
}

output "ecs_cluster_arn" {
  description = "The ARN of the cluster"
  value = join("", aws_ecs_cluster.this.*.arn)
}
