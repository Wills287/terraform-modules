/* ---------------------------------------------------------------------------------------------------------------------
  ENVIRONMENT VARIABLES
--------------------------------------------------------------------------------------------------------------------- */

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

/* ---------------------------------------------------------------------------------------------------------------------
  REQUIRED PARAMETERS
--------------------------------------------------------------------------------------------------------------------- */

variable "name" {
  description = "The name of the EC2 instance"
  type = string
}

/* ---------------------------------------------------------------------------------------------------------------------
  OPTIONAL PARAMETERS
--------------------------------------------------------------------------------------------------------------------- */

variable "region" {
  description = "The region to launch the instance in"
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
  default = "tc.micro"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type = number
  default = 8080
}

variable "tags" {
  description = "A map of tags to apply to the EC2 instance"
  type = "map"
  default = {}
}
