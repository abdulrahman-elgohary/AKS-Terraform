terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.12.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

# Define the Azure Provider
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
      recover_soft_deleted_key_vaults = true
    }
  }
  subscription_id = var.subscription_id

  
}

data "azurerm_client_config" "current" {}

#Create a staging resource group
resource "azurerm_resource_group" "rg-staging" {
  name     = var.rgname
  location = var.location
}

#Create an RBAC Role for the service principal to access the key vault
resource "azurerm_role_assignment" "keyvault_contributor_role" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Contributor"
  principal_id         = module.service_principal.service_principal_object_id
  depends_on          = [ module.service_principal ]
}

#Create an RBAC Role for Terraform to be able to create secrets inside the key vault
resource "azurerm_role_assignment" "staging_terraform_key_vault_officer" {
  scope                = module.keyvault.keyvault_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
  depends_on          = [ module.keyvault ]
}


module "service_principal" {
  source = "../modules/service_principal"
  service_principal_name = var.service_principal_name 
  depends_on = [ azurerm_resource_group.rg-staging ]
}




module "keyvault" {
  source = "../modules/keyvault"
  keyvault_name = var.keyvault_name
  location = var.location
  resource_group_name = var.rgname
  service_principal_name = var.service_principal_name
  service_principal_object_id = module.service_principal.service_principal_object_id
  service_principal_tenant_id = module.service_principal.service_principal_tenant_id
  
  depends_on = [module.service_principal,azurerm_resource_group.rg-staging]
  
}

#Create azure key vault Secret
resource "azurerm_key_vault_secret" "my_key_vault_secret" {
  name         = module.service_principal.client_id
  value        = module.service_principal.client_secret
  key_vault_id = module.keyvault.keyvault_id

  depends_on = [ module.keyvault, azurerm_role_assignment.staging_terraform_key_vault_officer ]

}


# Create Azure Kubernetes Service (AKS) Cluster
module "aks" {
  source              = "../modules/aks"
  cluster_name        = var.cluster_name
  location            = var.location
  resource_group_name = var.rgname
  client_id = module.service_principal.client_id
  client_secret = module.service_principal.client_secret
  service_principal_name = var.service_principal_name
  node_pool_name = var.node_pool_name
  vm_size = var.vm_size
  depends_on         = [module.service_principal]
}  


resource "local_file" "kubeconfig" {
  depends_on   = [module.aks]
  filename     = "./kubeconfig"
  content      = module.aks.config
  
}