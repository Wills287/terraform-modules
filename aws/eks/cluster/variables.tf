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

variable "vpc_id" {
  description = "VPC id to provision EKS cluster within"
  type = string
}

variable "subnet_ids" {
  description = "List of subnet ids to launch the cluster in"
  type = list(string)
}

variable "kubernetes_version" {
  description = "Desired Kubernetes version, e.g. '1.15'"
  type = string
}

/* ---------------------------------------------------------------------------------------------------------------------
  OPTIONAL VARIABLES
--------------------------------------------------------------------------------------------------------------------- */

variable "allowed_security_groups" {
  description = "List of Security group ids allowed to connect to the EKS cluster"
  type = list(string)
  default = []
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to connect to the EKS cluster"
  type = list(string)
  default = []
}

variable "workers_role_arns" {
  description = "List of Role ARNs of the worker nodes"
  type = list(string)
  default = []
}

variable "workers_security_group_ids" {
  description = "Security group ids of the worker nodes"
  type = list(string)
  default = []
}

variable "oidc_provider_enabled" {
  description = "Create an IAM OIDC identity provider for the cluster, allowing association of IAM roles with service accounts"
  type = bool
  default = false
}

variable "endpoint_private_access" {
  description = "Flag enabling the Amazon EKS private API server endpoint"
  type = bool
  default = false
}

variable "endpoint_public_access" {
  description = "Flag enabling the Amazon EKS public API server endpoint"
  type = bool
  default = true
}

variable "public_access_cidrs" {
  description = "Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled"
  type = list(string)
  default = [
    "0.0.0.0/0"
  ]
}

variable "enabled_cluster_log_types" {
  description = "A list of control plane aspects to enable logging for, available options: ['api', 'audit', 'authenticator', 'controllerManager', 'scheduler']"
  type = list(string)
  default = []
}

variable "cluster_log_retention_period" {
  description = "Number of days to retain cluster logs. Requires 'enabled_cluster_log_types' to be set"
  type = number
  default = 0
}

variable "apply_config_map_aws_auth" {
  description = "Whether to apply the ConfigMap to allow worker nodes to join the EKS cluster and allow additional users, accounts and roles to acces the cluster"
  type = bool
  default = true
}

variable "map_additional_aws_accounts" {
  description = "Additional AWS account numbers to add to the 'config-map-aws-auth' ConfigMap"
  type = list(string)
  default = []
}

variable "map_additional_iam_roles" {
  description = "Additional IAM roles to add to the 'config-map-aws-auth' ConfigMap"

  type = list(object({
    rolearn = string
    username = string
    groups = list(string)
  }))

  default = []
}

variable "map_additional_iam_users" {
  description = "Additional IAM users to add to the 'config-map-aws-auth' ConfigMap"

  type = list(object({
    userarn = string
    username = string
    groups = list(string)
  }))

  default = []
}

variable "local_exec_interpreter" {
  description = "Shell to use for local_exec"
  type = list(string)
  default = [
    "/bin/sh",
    "-c"
  ]
}

variable "wait_for_cluster_command" {
  description = "'local-exec' command to execute when determining if the EKS cluster is healthy"
  type = string
  default = "curl --silent --fail --retry 60 --retry-delay 5 --retry-connrefused --insecure --output /dev/null $ENDPOINT/healthz"
}

variable "kubernetes_config_map_ignore_role_changes" {
  description = "If 'true', will ignore IAM role changes in the Kubernetes Auth ConfigMap"
  type = bool
  default = true
}
