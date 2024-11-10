output "name" {
  description = "The name of the key value that was deployed."
  value       = azapi_resource.keyvaules.name
}

output "resource_id" {
  description = "The resource ID of the replica that was deployed."
  value       = azapi_resource.keyvaules.id
}
