resource "azapi_resource" "keyvaules" {
  type      = "Microsoft.AppConfiguration/configurationStores/keyValues@2023-03-01"
  name      = var.name
  parent_id = var.app_configuration.resource_id
  body = jsonencode({
    properties = {
      contentType = var.content_type
      tags        = var.tags
      value       = var.value
    }
  })
}
