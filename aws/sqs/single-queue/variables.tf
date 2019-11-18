/* ---------------------------------------------------------------------------------------------------------------------
  ENVIRONMENT VARIABLES
--------------------------------------------------------------------------------------------------------------------- */

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

/* ---------------------------------------------------------------------------------------------------------------------
  REQUIRED PARAMETERS
--------------------------------------------------------------------------------------------------------------------- */

variable "name" {
  description = "The name of the SQS queue"
  type = string
}

/* ---------------------------------------------------------------------------------------------------------------------
  OPTIONAL PARAMETERS
--------------------------------------------------------------------------------------------------------------------- */

variable "max_message_size" {
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it"
  type = number
  default = 262144
}

variable "visibility_timeout" {
  description = "The visibility timeout for the queue in seconds"
  type = number
  default = 30
}

variable "message_retention" {
  description = "The number of seconds Amazon SQS retains a message in seconds"
  type = number
  default = 345600
}

variable "delay" {
  description = "The time in seconds that the delivery of all messages in the queue will be delayed"
  type = number
  default = 0
}

variable "receive_wait_time" {
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning in seconds"
  type = number
  default = 0
}

variable "tags" {
  description = "A map of tags to apply to the SQS queue"
  type = "map"
  default = {}
}
