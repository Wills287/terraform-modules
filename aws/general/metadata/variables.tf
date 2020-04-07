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
  OPTIONAL VARIABLES
--------------------------------------------------------------------------------------------------------------------- */

variable "additional_tag_map" {
  description = "Additional tags for appending to each tag map"
  type = map(string)
  default = {}
}

variable "context" {
  description = "Default context to use for passing state between label invocations"
  type = object({
    enabled = bool
    namespace = string
    environment = string
    name = string
    service = string
    delimiter = string
    attributes = list(string)
    label_order = list(string)
    tags = map(string)
    additional_tag_map = map(string)
    regex_accepted_characters = string
  })
  default = {
    enabled = true
    namespace = ""
    environment = ""
    name = ""
    service = ""
    delimiter = ""
    attributes = []
    label_order = []
    tags = {}
    additional_tag_map = {}
    regex_accepted_characters = ""
  }
}

variable "label_order" {
  description = "The naming order used when generating an id and name"
  type = list(string)
  default = []
}

variable "regex_accepted_characters" {
  description = "Regex defining acceptable characters in 'namespace', 'environment', 'name' and 'service'. By default only hyphens, letters and digits are acceptable, all other chars are removed"
  type = string
  default = "/[^a-zA-Z0-9-]/"
}
