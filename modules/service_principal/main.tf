#Fetch the client id of the current user to assign permissions to the service principal
data "azuread_client_config" "current" {}

#Create an App Registration for the service principal
resource "azuread_application" "main_app" {
  display_name = var.service_principal_name
  owners = [data.azuread_client_config.current.object_id]
}

#Create a service principal for the application
resource "azuread_service_principal" "main_sp" {
  client_id = azuread_application.main_app.client_id
  app_role_assignment_required = true
  owners = [data.azuread_client_config.current.object_id]
}

#Create a Password for the Service Principal
resource "azuread_service_principal_password" "main_sp_password" {
  service_principal_id = azuread_service_principal.main_sp.id
}

/* 
Current Terraform identity
        |
        v
Terraform reads its object_id
        |
        v
Creates App Registration named "example"
        |
        v
Makes current Terraform identity owner of the App Registration
        |
        v
Creates Service Principal linked to that App Registration
        |
        v
Makes current Terraform identity owner of the Service Principal
*/