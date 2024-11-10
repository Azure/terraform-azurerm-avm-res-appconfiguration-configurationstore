# TODO: insert locals here.
locals {
  managed_identities = {
    system_assigned_user_assigned = (var.managed_identities.system_assigned || length(var.managed_identities.user_assigned_resource_ids) > 0) ? {
      this = {
        type                       = var.managed_identities.system_assigned && length(var.managed_identities.user_assigned_resource_ids) > 0 ? "SystemAssigned, UserAssigned" : length(var.managed_identities.user_assigned_resource_ids) > 0 ? "UserAssigned" : "SystemAssigned"
        user_assigned_resource_ids = var.managed_identities.user_assigned_resource_ids
      }
    } : {}
    system_assigned = var.managed_identities.system_assigned ? {
      this = {
        type = "SystemAssigned"
      }
    } : {}
    user_assigned = length(var.managed_identities.user_assigned_resource_ids) > 0 ? {
      this = {
        type                       = "UserAssigned"
        user_assigned_resource_ids = var.managed_identities.user_assigned_resource_ids
      }
    } : {}
  }
  # Private endpoint application security group associations.
  # We merge the nested maps from private endpoints and application security group associations into a single map.
  private_endpoint_application_security_group_associations = { for assoc in flatten([
    for pe_k, pe_v in var.private_endpoints : [
      for asg_k, asg_v in pe_v.application_security_group_associations : {
        asg_key         = asg_k
        pe_key          = pe_k
        asg_resource_id = asg_v
      }
    ]
  ]) : "${assoc.pe_key}-${assoc.asg_key}" => assoc }
  cmk_keyvault_name                  = var.customer_managed_key != null ? element(split("/", var.customer_managed_key.key_vault_resource_id), 8) : null
  cmk_uai_name                       = var.customer_managed_key != null ? element(split("/", var.customer_managed_key.user_assigned_identity.resource_id), 8) : null
  cmk_uai_rg_name                    = var.customer_managed_key != null ? element(split("/", var.customer_managed_key.user_assigned_identity.resource_id), 4) : null
  cmk_uai_subscription_id            = var.customer_managed_key != null ? element(split("/", var.customer_managed_key.user_assigned_identity.resource_id), 2) : null
  cmk_uai_client_id                  = var.customer_managed_key != null ? data.azapi_resource.user_assigned_identity[0].output.properties.clientId : null
  normalized_cmk_key_url             = var.customer_managed_key != null ? "https://${local.cmk_keyvault_name}.vault.azure.net/keys/${var.customer_managed_key.key_name}" : null
  role_definition_resource_substring = "/providers/Microsoft.Authorization/roleDefinitions"
  subscription_id                    = coalesce(var.subscription_id, data.azurerm_client_config.this.subscription_id)
}
