 # Create a backend block for azure in the Dev Environment
terraform {
  backend "azurerm" {
    resource_group_name  = "dev-terraform-rg"
    storage_account_name = "devtfaksstorage"
    container_name       = "dev-tfstate"
    key                  = "dev.terraform.tfstate"
  }
}
