output "name" {
  description = "The resource name of the app configuration store."
  value       = azapi_resource.appconfigstore.name
}

output "private_endpoints" {
  description = <<DESCRIPTION
  A map of the private endpoints created.
  DESCRIPTION
  value       = var.private_endpoints_manage_dns_zone_group ? azurerm_private_endpoint.this_managed_dns_zone_groups : azurerm_private_endpoint.this_unmanaged_dns_zone_groups
}

output "resource_id" {
  description = "The resource ID of the app configuration store."
  value       = azapi_resource.appconfigstore.id
}
