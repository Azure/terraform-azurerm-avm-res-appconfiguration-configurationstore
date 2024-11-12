resource "azapi_resource" "appconfigreplica" {
  type      = "Microsoft.AppConfiguration/configurationStores/replicas@2023-03-01"
  location  = var.replica_location
  name      = var.name
  parent_id = var.app_configuration.resource_id
}
