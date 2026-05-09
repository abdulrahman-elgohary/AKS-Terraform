#Define the Terraform version
terraform {
  required_version = "1.14.8"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.0.0"
    }

  }
}

# Define the Azure Provider
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
  subscription_id = var.subscription_id
}

#Create a dev resource group
resource "azurerm_resource_group" "rg-dev" {
  name     = var.rgname
  location = var.location
}

#Use the Service Principal module
module "service_principal" {
  source                 = "../modules/service_principal"
  service_principal_name = var.service_principal_name
  depends_on             = [azurerm_resource_group.rg-dev]
}


#Create an RBAC Role 
resource "azurerm_role_assignment" "keyvault_contributor_role" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = module.service_principal.service_principal_object_id
  depends_on           = [module.service_principal]
}


module "keyvault" {
  source                      = "../modules/keyvault"
  keyvault_name            = var.keyvault_name
  location                    = var.location
  resource_group_name         = var.rgname
  service_principal_name      = var.service_principal_name
  service_principal_object_id = module.service_principal.service_principal_object_id
  service_principal_tenant_id = module.service_principal.service_principal_tenant_id

  depends_on = [module.service_principal, azurerm_resource_group.rg-dev]

}

#Create azure key vault Secret
resource "azurerm_key_vault_secret" "my_key_vault_secret" {
  name         = module.service_principal.client_id
  value        = module.service_principal.client_secret
  key_vault_id = module.keyvault.keyvault_id

  depends_on = [module.keyvault]

}