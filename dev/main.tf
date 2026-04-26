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
  features {}
  subscription_id = var.subscription_id
}

#Create a dev resource group
resource "azurerm_resource_group" "rg-dev" {
  name     = var.rgname
  location = var.location
}

#Use the Service Principal module
module "service_principal" {
  source = "../modules/service_principal"
  service_principal_name = var.service_principal_name 
  depends_on = [ azurerm_resource_group.rg-dev ]
}
 
