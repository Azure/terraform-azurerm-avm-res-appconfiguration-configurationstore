data "azurerm_client_config" "this" {}

data "azapi_resource" "user_assigned_identity" {
  count = var.customer_managed_key != null ? 1 : 0

  type                   = "Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31"
  name                   = local.cmk_uai_name
  parent_id              = "/subscriptions/${local.cmk_uai_subscription_id}/resourcegroups/${local.cmk_uai_rg_name}"
  response_export_values = ["properties.clientId"]
}
