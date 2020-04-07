output "id" {
  description = "Disambiguated id"
  value = local.enabled ? local.id : ""
}

output "namespace" {
  description = "Normalized namespace"
  value = local.enabled ? local.namespace : ""
}

output "environment" {
  description = "Normalized environment"
  value = local.enabled ? local.environment : ""
}

output "name" {
  description = "Normalized name"
  value = local.enabled ? local.name : ""
}

output "service" {
  description = "Normalized service"
  value = local.enabled ? local.service : ""
}

output "attributes" {
  description = "List of attributes"
  value = local.enabled ? local.attributes : []
}

output "delimiter" {
  description = "Delimiter to output between 'namespace', 'environment', 'name', 'service' and 'attributes'"
  value = local.enabled ? local.delimiter : ""
}

output "tags" {
  description = "Normalized tags"
  value = local.enabled ? local.tags : {}
}

output "tags_as_list_of_maps" {
  description = "Additional tags as a list of maps, which can be used in several AWS resources"
  value = local.tags_as_list_of_maps
}

output "context" {
  description = "Context of this module to pass to other metadata modules"
  value = local.output_context
}

output "label_order" {
  description = "The naming order used when generating an id and name"
  value = local.label_order
}
