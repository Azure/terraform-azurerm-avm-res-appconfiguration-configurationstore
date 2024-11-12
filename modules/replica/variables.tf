variable "app_configuration" {
  type = object({
    resource_id = string
  })
  description = "The App Configuration resource for which replicas are being created"
  nullable    = false
}

variable "name" {
  type        = string
  description = "Name of the replica"
  nullable    = false
}

variable "replica_location" {
  type        = string
  description = "Location of the replica"
  nullable    = false
}
