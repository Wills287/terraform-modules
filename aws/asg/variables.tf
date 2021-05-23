/* ---------------------------------------------------------------------------------------------------------------------
  ENVIRONMENT VARIABLES
--------------------------------------------------------------------------------------------------------------------- */

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

/* ---------------------------------------------------------------------------------------------------------------------
  METADATA VARIABLES
--------------------------------------------------------------------------------------------------------------------- */

variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  type = bool
  default = true
}

variable "namespace" {
  description = "Namespace, which may relate to the overarching domain or specific business division"
  type = string
  default = ""
}

variable "environment" {
  description = "Describes the environment, e.g. 'PROD', 'staging', 'u', 'dev'"
  type = string
  default = ""
}

variable "name" {
  description = "Identifier for a specific application that may consist of many disparate resources"
  type = string
  default = ""
}

variable "service" {
  description = "Describes an individual microservice running as part of a larger application"
  type = string
  default = ""
}

variable "delimiter" {
  description = "Delimiter to output between 'namespace', 'environment', 'name', 'service' and 'attributes'"
  type = string
  default = "-"
}

variable "attributes" {
  description = "Any additional miscellaneous attributes to append to the identifier, e.g. 'cluster', 'worker'"
  type = list(string)
  default = []
}

variable "tags" {
  description = "Additional tags to apply, e.g. '{Owner = 'ABC', Product = 'DEF'}'"
  type = map(string)
  default = {}
}

/* ---------------------------------------------------------------------------------------------------------------------
  REQUIRED VARIABLES
--------------------------------------------------------------------------------------------------------------------- */

variable "instance_type" {
  description = "Instance type to launch"
  type        = string
}

variable "max_size" {
  description = "The maximum size of the autoscale group"
  type        = number
}

variable "min_size" {
  description = "The minimum size of the autoscale group"
  type        = number
}

variable "desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  type        = number
}

variable "subnet_ids" {
  description = "A list of subnet IDs to launch resources in"
  type        = list(string)
}

/* ---------------------------------------------------------------------------------------------------------------------
  OPTIONAL VARIABLES
--------------------------------------------------------------------------------------------------------------------- */

variable "image_id" {
  description = "The EC2 image ID to launch"
  type        = string
  default     = ""
}

variable "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior for the instances. 'stop' or 'terminate'"
  type        = string
  default     = "terminate"
}

variable "iam_instance_profile_name" {
  description = "The IAM instance profile name to associate with launched instances"
  type        = string
  default     = ""
}

variable "key_name" {
  description = "The SSH key name that should be used for the instance"
  type        = string
  default     = ""
}

variable "security_group_ids" {
  description = "A list of associated security group IDs"
  type        = list(string)
  default     = []
}

variable "launch_template_version" {
  description = "Launch template version. Can be version number, '$Latest' or '$Default'"
  type        = string
  default     = "$Latest"
}

variable "associate_public_ip_address" {
  description = "Associate a public IP address with an instance in a VPC"
  type        = bool
  default     = false
}

variable "user_data_base64" {
  description = "The Base64-encoded user data to provide when launching the instances"
  type        = string
  default     = ""
}

variable "enable_monitoring" {
  description = "Enable/disable detailed monitoring"
  type        = bool
  default     = true
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  type        = bool
  default     = false
}

variable "default_cooldown" {
  description = "The amount of time, in seconds, after a scaling activity completes before another scaling activity can start"
  type        = number
  default     = 300
}

variable "health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
  type        = number
  default     = 300
}

variable "health_check_type" {
  description = "Controls how health checking is done. Valid values are 'EC2' or 'ELB'"
  type        = string
  default     = "EC2"
}

variable "force_delete" {
  description = "Allows deleting the autoscaling group without waiting for all instances in the pool to terminate. You can force an autoscaling group to delete even if it's in the process of scaling a resource. Normally, Terraform drains all the instances before deleting the group. This bypasses that behavior and potentially leaves resources dangling"
  type        = bool
  default     = false
}

variable "load_balancers" {
  description = "A list of elastic load balancer names to add to the autoscaling group names. Only valid for classic load balancers. For ALBs, use 'target_group_arns' instead"
  type        = list(string)
  default     = []
}

variable "target_group_arns" {
  description = "A list of aws_alb_target_group ARNs, for use with Application Load Balancing"
  type        = list(string)
  default     = []
}

variable "termination_policies" {
  description = "A list of policies to decide how the instances in the auto scale group should be terminated. The allowed values are 'OldestInstance', 'NewestInstance', 'OldestLaunchConfiguration', 'ClosestToNextInstanceHour', 'Default'"
  type        = list(string)
  default     = ["Default"]
}

variable "suspended_processes" {
  description = "A list of processes to suspend for the AutoScaling Group. The allowed values are 'Launch', 'Terminate', 'HealthCheck', 'ReplaceUnhealthy', 'AZRebalance', 'AlarmNotification', 'ScheduledActions', 'AddToLoadBalancer'. Note that if you suspend either the 'Launch' or 'Terminate' process types, it can prevent your autoscaling group from functioning properly."
  type        = list(string)
  default     = []
}

variable "placement_group" {
  description = "The name of the placement group into which you'll launch your instances, if any"
  type        = string
  default     = ""
}

variable "metrics_granularity" {
  description = "The granularity to associate with the metrics to collect. The only valid value is 1Minute"
  type        = string
  default     = "1Minute"
}

variable "enabled_metrics" {
  description = "A list of metrics to collect. The allowed values are 'GroupMinSize', 'GroupMaxSize', 'GroupDesiredCapacity', 'GroupInServiceInstances', 'GroupPendingInstances', 'GroupStandbyInstances', 'GroupTerminatingInstances', 'GroupTotalInstances'"
  type        = list(string)

  default = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]
}

variable "disable_api_termination" {
  description = "If 'true', enables EC2 Instance Termination Protection"
  type        = bool
  default     = false
}

variable "autoscaling_policies_enabled" {
  description = "Whether to create 'aws_autoscaling_policy' and 'aws_cloudwatch_metric_alarm' resources to control Auto Scaling"
  type        = bool
  default     = true
}

variable "scale_up_cooldown_seconds" {
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start"
  type        = number
  default     = 300
}

variable "scale_up_scaling_adjustment" {
  description = "The number of instances by which to scale. 'scale_up_adjustment_type' determines the interpretation of this number (e.g. as an absolute number or as a percentage of the existing Auto Scaling group size). A positive increment adds to the current capacity and a negative value removes from the current capacity"
  type        = number
  default     = 1
}

variable "scale_up_adjustment_type" {
  description = "Specifies whether the adjustment is an absolute number or a percentage of the current capacity. Valid values are 'ChangeInCapacity', 'ExactCapacity' and 'PercentChangeInCapacity'"
  type        = string
  default     = "ChangeInCapacity"
}

variable "scale_up_policy_type" {
  description = "The scaling policy type. Currently only 'SimpleScaling' is supported"
  type        = string
  default     = "SimpleScaling"
}

variable "scale_down_cooldown_seconds" {
  description = "The amount of time, in seconds, after a scaling activity completes and before the next scaling activity can start"
  type        = number
  default     = 300
}

variable "scale_down_scaling_adjustment" {
  description = "The number of instances by which to scale. 'scale_down_scaling_adjustment' determines the interpretation of this number (e.g. as an absolute number or as a percentage of the existing Auto Scaling group size). A positive increment adds to the current capacity and a negative value removes from the current capacity"
  type        = number
  default     = -1
}

variable "scale_down_adjustment_type" {
  description = "Specifies whether the adjustment is an absolute number or a percentage of the current capacity. Valid values are 'ChangeInCapacity', 'ExactCapacity' and 'PercentChangeInCapacity'"
  type        = string
  default     = "ChangeInCapacity"
}

variable "scale_down_policy_type" {
  description = "The scaling policy type. Currently only 'SimpleScaling' is supported"
  type        = string
  default     = "SimpleScaling"
}

variable "cpu_utilization_high_evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold"
  type        = number
  default     = 2
}

variable "cpu_utilization_high_period_seconds" {
  description = "The period in seconds over which the specified statistic is applied"
  type        = number
  default     = 300
}

variable "cpu_utilization_high_threshold_percent" {
  description = "The value against which the specified statistic is compared"
  type        = number
  default     = 90
}

variable "cpu_utilization_high_statistic" {
  description = "The statistic to apply to the alarm's associated metric. Either of the following is supported: 'SampleCount', 'Average', 'Sum', 'Minimum', 'Maximum'"
  type        = string
  default     = "Average"
}

variable "cpu_utilization_low_evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold"
  type        = number
  default     = 2
}

variable "cpu_utilization_low_period_seconds" {
  description = "The period in seconds over which the specified statistic is applied"
  type        = number
  default     = 300
}

variable "cpu_utilization_low_threshold_percent" {
  description = "The value against which the specified statistic is compared"
  type        = number
  default     = 10
}

variable "cpu_utilization_low_statistic" {
  description = "The statistic to apply to the alarm's associated metric. Either of the following is supported: 'SampleCount', 'Average', 'Sum', 'Minimum', 'Maximum'"
  type        = string
  default     = "Average"
}

variable "tag_specifications_resource_types" {
  description = "List of tag specification resource types to tag. Valid values are 'instance', 'volume', 'elastic-gpu' and 'spot-instances-request'"
  type        = set(string)
  default     = ["instance", "volume"]
}
