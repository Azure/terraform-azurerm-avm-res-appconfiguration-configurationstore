output "name" {
  description = "The The name of the replica that was deployed."
  value       = azapi_resource.appconfigreplica.name
}

output "resource_id" {
  description = "The resource ID of the replica that was deployed."
  value       = azapi_resource.appconfigreplica.id
}
