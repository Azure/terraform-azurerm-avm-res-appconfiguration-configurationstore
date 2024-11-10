resource "azapi_resource" "appconfigreplica" {
  type      = "Microsoft.AppConfiguration/configurationStores/replicas@2023-03-01"
  name      = var.name
  location  = var.replica_location
  parent_id = var.app_configuration.resource_id
}
