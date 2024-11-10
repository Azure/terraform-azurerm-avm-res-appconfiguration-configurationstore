variable "name" {
  description = "Name of the key"
  type        = string
  nullable    = false
}

variable "content_type" {
  description = "Content type of the key"
  type        = string
  nullable    = false
}

variable "value" {
  description = "Value of the key"
  type        = string
  nullable    = false
}

variable "tags" {
  description = "Tags for the key"
  type        = map(string)
  nullable    = true
  default     = null
}

variable "app_configuration" {
  description = "The App Configuration resource for which replicas are being created"
  type = object({
    resource_id = string
  })
  nullable = false
}

