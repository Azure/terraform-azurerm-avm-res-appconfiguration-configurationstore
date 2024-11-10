variable "app_configuration" {
  type = object({
    resource_id = string
  })
  description = "The App Configuration resource for which replicas are being created"
  nullable    = false
}

variable "content_type" {
  type        = string
  description = "Content type of the key"
  nullable    = false
}

variable "name" {
  type        = string
  description = "Name of the key"
  nullable    = false
}

variable "value" {
  type        = string
  description = "Value of the key"
  nullable    = false
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Tags for the key"
}
