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

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type = string
}

variable "subnet_ids" {
  description = "A list of subnet ids to launch resources in"
  type = list(string)
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type = number
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type = number
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type = number
}

/* ---------------------------------------------------------------------------------------------------------------------
  OPTIONAL VARIABLES
--------------------------------------------------------------------------------------------------------------------- */

variable "instance_types" {
  description = "Set of instance types associated with the EKS Node Group"
  type = list(string)
  default = [
    "t3.medium"
  ]
}

variable "ami_type" {
  description = "Type of AMI associated with the EKS Node Group. Valid values: 'AL2_x86_64', 'AL2_x86_64_GPU'"
  type = string
  default = "AL2_x86_64"
}

variable "ec2_ssh_key" {
  description = "Name of the SSH key used for accessing the nodes"
  type = string
  default = null
}

variable "existing_workers_role_policy_arns" {
  description = "List of existing policy ARNs that will be attached to the workers default role on creation"
  type = list(string)
  default = []
}

variable "existing_workers_role_policy_arns_count" {
  description = "Count of existing policy ARNs that will be attached to the workers default role on creation. Needed to prevent Terraform error 'count can't be computed'"
  type = number
  default = 0
}

variable "disk_size" {
  description = "Disk size in GiB for worker nodes"
  type = number
  default = 20
}

variable "kubernetes_labels" {
  description = "Key-value mapping of Kubernetes labels. Only labels that are applied with the EKS API are managed by this argument. Other Kubernetes labels applied to the EKS Node Group will not be managed"
  type = map(string)
  default = {}
}

variable "ami_release_version" {
  description = "AMI version of the EKS Node Group. Defaults to latest version for the associated Kubernetes version"
  type = string
  default = null
}

variable "kubernetes_version" {
  description = "Kubernetes version. Defaults to the EKS Cluster Kubernetes version"
  type = string
  default = null
}

variable "source_security_group_ids" {
  description = "Set of EC2 security group ids to allow SSH access (port 22) from on the worker nodes. If you specify 'ec2_ssh_key', but do not specify this configuration when you create an EKS Node Group, port 22 on the worker nodes is opened to the Internet (0.0.0.0/0)"
  type = list(string)
  default = []
}

variable "enable_cluster_autoscaler" {
  description = "Whether to enable the cluster autoscaler"
  type = bool
  default = false
}

variable "module_depends_on" {
  description = "Module will wait for this value to be computed before creating the node group"
  type = any
  default = null
}
