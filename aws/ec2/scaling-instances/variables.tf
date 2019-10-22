/* ---------------------------------------------------------------------------------------------------------------------
  ENVIRONMENT VARIABLES
--------------------------------------------------------------------------------------------------------------------- */

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

/* ---------------------------------------------------------------------------------------------------------------------
  REQUIRED PARAMETERS
--------------------------------------------------------------------------------------------------------------------- */

variable "name" {
  description = "The name to be associated with created resources"
  type = string
}

/* ---------------------------------------------------------------------------------------------------------------------
  OPTIONAL PARAMETERS
--------------------------------------------------------------------------------------------------------------------- */

variable "region" {
  description = "The region to launch the instances in"
  type = string
  default = "eu-west-1"
}

variable "ami" {
  description = "A map of regions and their associated AMIs"
  type = "map"
  default = {
    eu-west-1 = "ami-0ce71448843cb18a1"
    us-east-1 = "ami-0b69ea66ff7391e80"
  }
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t3.micro)"
  type = string
  default = "t3.micro"
}

variable "min_size" {
  description = "The minimum number of instances to provision within the group"
  type = number
  default = 2
}

variable "max_size" {
  description = "The maximum number of instances to provision within the group"
  type = number
  default = 6
}

variable "desired" {
  description = "The desired number of instances to initially provision"
  type = number
  default = 2
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type = number
  default = 8080
}

variable "elb_port" {
  description = "The port the ELB will use for HTTP requests"
  type = number
  default = 80
}

variable "tags" {
  description = "A map of tags to apply to the EC2 instance"
  type = "map"
  default = {}
}
