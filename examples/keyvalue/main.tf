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
  sku                 = "free"
  enable_telemetry    = var.enable_telemetry
  key_values = {
    key0 = {
      name  = "key0$hello"
      value = "value0"
    }
    key1 = {
      name         = "key1$testdollar"
      content_type = "application/vnd.microsoft.appconfig.keyvaultref+json;charset=utf-8"
      value        = "https://desakv.vault.azure.net/secrets/samplesecret"
    }
  }
}
