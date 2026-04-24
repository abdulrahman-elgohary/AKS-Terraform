# Create a backend block for azure in the Staging Environment
terraform {
  backend "azurerm" {
    resource_group_name  = "staging-terraform-rg"
    storage_account_name = "stagingtfaksstorage"
    container_name       = "staging-tfstate"
    key                  = "staging.terraform.tfstate"
  }
}
