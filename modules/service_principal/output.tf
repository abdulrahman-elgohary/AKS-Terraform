output "service_principal_name" {
  value = azuread_service_principal.main_sp.display_name
  description = "The object name of service principal. Can be used to assign roles to user."
}

output "service_principal_object_id" {
  value = azuread_service_principal.main_sp.id
  description = "The object id of service principal. Can be used to assign roles to user."
}

output "service_principal_tenant_id" {
  value = azuread_service_principal.main_sp.application_tenant_id
}

output "client_id" {
  value = azuread_application.main_app.client_id
  description = "The client id of the service principal. Can be used to authenticate with the service principal."
}

output "client_secret" {
  value = azuread_service_principal_password.main_sp_password.value
  description = "Password for Service Principal"
}