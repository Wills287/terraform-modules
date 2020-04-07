locals {
  defaults = {
    label_order = [
      "namespace",
      "environment",
      "name",
      "service",
      "attributes"
    ]
    delimiter = "-"
    replacement = ""
    # The 'sentinel' should be a value not allowed by 'regex_accepted_characters', this allows it to be replaced with the 'replacement' value
    sentinel = "~"
    attributes = [
      ""
    ]
  }

  enabled = var.enabled
  regex_accepted_characters = coalesce(var.regex_accepted_characters, var.context.regex_accepted_characters)

  # The values provided by variables supersede the values inherited from the context
  namespace = lower(replace(coalesce(var.namespace, var.context.namespace, local.defaults.sentinel), local.regex_accepted_characters, local.defaults.replacement))
  environment = lower(replace(coalesce(var.environment, var.context.environment, local.defaults.sentinel), local.regex_accepted_characters, local.defaults.replacement))
  name = lower(replace(coalesce(var.name, var.context.name, local.defaults.sentinel), local.regex_accepted_characters, local.defaults.replacement))
  service = lower(replace(coalesce(var.service, var.context.service, local.defaults.sentinel), local.regex_accepted_characters, local.defaults.replacement))
  delimiter = coalesce(var.delimiter, var.context.delimiter, local.defaults.delimiter)
  label_order = length(var.label_order) > 0 ? var.label_order : (length(var.context.label_order) > 0 ? var.context.label_order : local.defaults.label_order)

  attributes = compact(distinct(concat(var.attributes, var.context.attributes, local.defaults.attributes)))

  tags = merge(var.context.tags, local.generated_tags, var.tags)
  additional_tag_map = merge(var.context.additional_tag_map, var.additional_tag_map)

  tags_as_list_of_maps = flatten([
  for key in keys(local.tags) : merge(
  {
    key = key
    value = local.tags[key]
  }, var.additional_tag_map)
  ])

  tags_context = {
    name = local.id
    namespace = local.namespace
    environment = local.environment
    service = local.service
    attributes = local.id_context.attributes
  }

  generated_tags = {for l in keys(local.tags_context) : title(l) => local.tags_context[l] if length(local.tags_context[l]) > 0}

  id_context = {
    name = local.name
    namespace = local.namespace
    environment = local.environment
    service = local.service
    attributes = lower(replace(join(local.delimiter, local.attributes), local.regex_accepted_characters, local.defaults.replacement))
  }

  labels = [for l in local.label_order : local.id_context[l] if length(local.id_context[l]) > 0]
  id = lower(join(local.delimiter, local.labels))

  output_context = {
    enabled = local.enabled
    name = local.name
    namespace = local.namespace
    environment = local.environment
    service = local.service
    attributes = local.attributes
    tags = local.tags
    delimiter = local.delimiter
    label_order = local.label_order
    regex_accepted_characters = local.regex_accepted_characters
    additional_tag_map = local.additional_tag_map
  }
}
