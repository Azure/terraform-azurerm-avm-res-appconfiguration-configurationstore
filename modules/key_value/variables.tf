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
}

variable "name" {
  type        = string
  description = "Name of the key"
  nullable    = false
}

variable "value" {
  type        = string
  description = <<DESCRIPTION
A map of key value to be created. The following properties can be specified:

- `name` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
- `content_type` - (Optional) Specifies the content type of the key-value resources. For feature flag, the value should be application/vnd.microsoft.appconfig.ff+json;charset=utf-8. For Key Value reference, the value should be application/vnd.microsoft.appconfig.keyvaultref+json;charset=utf-8. Otherwise, it's optional.
- `value` - (Required) Specifies the values of the key-value resources. For Key Vault Ref, the value should be the Keyvault secret url provided in this format: Format should be https://{vault-name}.{vault-DNS-suffix}/secrets/{secret-name}/{secret-version}. Secret version is optional.
- `tags` - (Optional) Adds tags for the key-value resources
DESCRIPTION
  nullable    = false
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Tags for the key"
}
