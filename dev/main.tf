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

