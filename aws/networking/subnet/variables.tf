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
  description = "Id of the VPC"
  type = string
}

variable "cidr_block" {
  description = "Base CIDR block which is divided into subnet CIDR blocks (e.g. '10.0.0.0/16')"
  type = string
}

variable "availability_zones" {
  description = "List of Availability Zones where subnets will be created"
  type = list(string)
}

/* ---------------------------------------------------------------------------------------------------------------------
  OPTIONAL VARIABLES
--------------------------------------------------------------------------------------------------------------------- */

variable "public_map_public_ip" {
  description = "Indicates that instances launched into public subnets should be assigned a public IP address"
  type = bool
  default = false
}

variable "public_network_acl_egress" {
  description = "Public subnet egress Network ACL rules"
  type = list(map(string))
  default = [
    {
      rule_no = 100
      action = "allow"
      cidr_block = "0.0.0.0/0"
      from_port = 0
      to_port = 0
      protocol = "-1"
    },
  ]
}

variable "public_network_acl_ingress" {
  description = "Public subnet ingress Network ACL rules"
  type = list(map(string))
  default = [
    {
      rule_no = 100
      action = "allow"
      cidr_block = "0.0.0.0/0"
      from_port = 0
      to_port = 0
      protocol = "-1"
    },
  ]
}

variable "private_network_acl_egress" {
  description = "Private subnet egress Network ACL rules"
  type = list(map(string))
  default = [
    {
      rule_no = 100
      action = "allow"
      cidr_block = "0.0.0.0/0"
      from_port = 0
      to_port = 0
      protocol = "-1"
    },
  ]
}

variable "private_network_acl_ingress" {
  description = "Private subnet ingress Network ACL rules"
  type = list(map(string))
  default = [
    {
      rule_no = 100
      action = "allow"
      cidr_block = "0.0.0.0/0"
      from_port = 0
      to_port = 0
      protocol = "-1"
    },
  ]
}

variable "nat_gateway_enabled" {
  description = "Flag enabling creation of NAT Gateways in public subnets"
  type = bool
  default = false
}
