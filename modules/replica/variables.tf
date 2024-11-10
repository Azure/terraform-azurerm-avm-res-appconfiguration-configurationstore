variable "name" {
  description = "Name of the replica"
  type        = string
  nullable    = false
}

variable "replica_location" {
  description = "Location of the replica"
  type        = string
  nullable    = false

}

variable "app_configuration" {
  description = "The App Configuration resource for which replicas are being created"
  type = object({
    resource_id = string
  })
  nullable = false
}

