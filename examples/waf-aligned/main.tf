terraform {
  required_version = "~> 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.6"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "843d07cf-6f9e-4d67-8977-79e491c12ab8"
}


## Section to provide a random Azure region for the resource group
# This allows us to randomize the region for the resource group.
module "regions" {
  source  = "Azure/avm-utl-regions/azurerm"
  version = "~> 0.1"
}

# This allows us to randomize the region for the resource group.
resource "random_integer" "region_index" {
  max = length(module.regions.regions) - 1
  min = 0
}
## End of section to provide a random Azure region for the resource group

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
}

# This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = module.regions.regions[random_integer.region_index.result].name
  name     = module.naming.resource_group.name_unique
}

# This is the module call
# Do not specify location here due to the randomization above.
# Leaving location as `null` will cause the module to use the resource group location
# with a data source.
module "appconfigurationstore" {
  source = "../../"
  # source             = "Azure/avm-res-appconfiguration-configurationstore/azurerm"
  # ...
  location            = azurerm_resource_group.this.location
  name                = module.naming.app_configuration.name_unique
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "standard"
  enable_telemetry    = var.enable_telemetry
  customer_managed_key = {
    key_vault_resource_id = ""
    key_name              = ""
    user_assigned_identity = {
      resource_id = ""
    }
  }
  managed_identities = {
    system_assigned = true
  }
  replicas = {
    replica0 = {
      name     = "replica0xyz"
      location = "eastus"
    }
    replica1 = {
      name     = "replica1xyz"
      location = "westus"
    }
  }
  key_values = {
    key0 = {
      name         = "key0"
      content_type = "text"
      value        = "value0"
    }
  }
}
