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

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type = string
}

/* ---------------------------------------------------------------------------------------------------------------------
  OPTIONAL VARIABLES
--------------------------------------------------------------------------------------------------------------------- */

variable "assign_ipv6_cidr_block" {
  description = "Flag for requesting an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC"
  type = bool
  default = false
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC, expects 'default' or 'dedicated'"
  type = string
  default = "default"
}

variable "enable_dns_hostnames" {
  description = "Flag for enabling/disabling DNS hostnames in the VPC"
  type = bool
  default = true
}

variable "enable_dns_support" {
  description = "Flag for enabling/disabling DNS support in the VPC"
  type = bool
  default = true
}

variable "enable_classiclink" {
  description = "Flag for enabling/disabling ClassicLink for the VPC"
  type = bool
  default = false
}

variable "enable_classiclink_dns_support" {
  description = "Flag for enabling/disabling ClassicLink DNS Support for the VPC"
  type = bool
  default = false
}

variable "override_default_security_group_rules" {
  description = "Removes the standard inbound and outbound rules from the default security group when set to true"
  type = bool
  default = true
}
