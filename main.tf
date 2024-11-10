/* resource "azurerm_app_configuration" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  local_auth_enabled  = var.local_auth_enabled
  public_network_access           = var.public_network_access == null ? (length(var.private_endpoints) == 0 ? "Enabled" : "Disabled") : var.public_network_access 
  purge_protection_enabled        = var.sku == "Free" ? false : var.purge_protection_enabled
  soft_delete_retention_days      = var.sku == "Free" ? 0 : var.soft_delete_retention_days
  tags                            = var.tags
} */

resource "azapi_resource" "appconfigstore" {
  type      = "Microsoft.AppConfiguration/configurationStores@2023-03-01"
  name      = var.name
  parent_id = "/subscriptions/${local.subscription_id}/resourceGroups/${var.resource_group_name}"
  tags      = var.tags
  dynamic "identity" {
    for_each = local.managed_identities.system_assigned_user_assigned
    content {
      type         = identity.value.type
      identity_ids = identity.value.user_assigned_resource_ids
    }
  }
  body = {
    location = var.location
    properties = {
      createMode            = var.create_mode
      disableLocalAuth      = var.local_auth_disabled
      enablePurgeProtection = var.sku == "free" ? false : var.purge_protection_enabled
      encryption = var.customer_managed_key != null ? {
        keyVaultProperties = {
          identityClientId = local.cmk_uai_client_id
          keyIdentifier    = local.normalized_cmk_key_url
        }
      } : {}
      publicNetworkAccess       = var.public_network_access == null ? (length(var.private_endpoints) == 0 ? "Enabled" : "Disabled") : var.public_network_access
      softDeleteRetentionInDays = var.sku == "free" ? 0 : var.soft_delete_retention_days
    }
    sku = {
      name = var.sku
    }
  }
}

module "replicas" {
  source   = "./modules/replica"
  for_each = var.replicas
  name     = each.value.name
  app_configuration = {
    resource_id = azapi_resource.appconfigstore.id
  }
  replica_location = each.value.location
}

module "key-values" {
  source   = "./modules/key-value"
  for_each = var.key_values
  name     = each.value.name
  app_configuration = {
    resource_id = azapi_resource.appconfigstore.id
  }
  content_type = each.value.content_type
  tags         = each.value.tags
  value        = each.value.value
}

resource "azurerm_management_lock" "this" {
  count = var.lock != null ? 1 : 0

  lock_level = var.lock.kind
  name       = coalesce(var.lock.name, "lock-${var.lock.kind}")
  scope      = azapi_resource.appconfigstore.id
  notes      = var.lock.kind == "CanNotDelete" ? "Cannot delete the resource or its child resources." : "Cannot delete or modify the resource or its child resources."

  depends_on = [azapi_resource.appconfigstore]
}

resource "azurerm_role_assignment" "this" {
  for_each = var.role_assignments

  principal_id                           = each.value.principal_id
  scope                                  = azapi_resource.appconfigstore.id
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
  role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check

  depends_on = [azapi_resource.appconfigstore]
}
