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
  type        = bool
  default     = true
}

variable "namespace" {
  description = "Namespace, which may relate to the overarching domain or specific business division"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Describes the environment, e.g. 'PROD', 'staging', 'u', 'dev'"
  type        = string
  default     = ""
}

variable "name" {
  description = "Identifier for a specific application that may consist of many disparate resources"
  type        = string
  default     = ""
}

variable "service" {
  description = "Describes an individual microservice running as part of a larger application"
  type        = string
  default     = ""
}

variable "delimiter" {
  description = "Delimiter to output between 'namespace', 'environment', 'name', 'service' and 'attributes'"
  type        = string
  default     = "-"
}

variable "attributes" {
  description = "Any additional miscellaneous attributes to append to the identifier, e.g. 'cluster', 'worker'"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags to apply, e.g. '{Owner = 'ABC', Product = 'DEF'}'"
  type        = map(string)
  default     = {}
}

/* ---------------------------------------------------------------------------------------------------------------------
  REQUIRED VARIABLES
--------------------------------------------------------------------------------------------------------------------- */

variable "vpc_id" {
  description = "The VPC id"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet ids to place the loadbalancer in"
  type        = list(string)
}

/* ---------------------------------------------------------------------------------------------------------------------
  OPTIONAL VARIABLES
--------------------------------------------------------------------------------------------------------------------- */

variable "deregistration_delay" {
  description = "The default deregistration delay"
  type        = number
  default     = "300"
}

variable "allow_cidr_block" {
  description = "Cidr block that is allowed to access the LoadBalancer"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
