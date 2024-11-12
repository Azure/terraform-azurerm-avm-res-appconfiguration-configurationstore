resource "azapi_resource" "keyvalues" {
  type = "Microsoft.AppConfiguration/configurationStores/keyValues@2024-05-01"
  body = {
    properties = {
      contentType = var.content_type
      tags        = var.tags
      value       = var.content_type == "application/vnd.microsoft.appconfig.keyvaultref+json;charset=utf-8" ? "{\"uri\":\"${var.value}\"}" : "${var.value}"
    }
  }
  name                      = var.name
  parent_id                 = var.app_configuration.resource_id
  schema_validation_enabled = true
}
