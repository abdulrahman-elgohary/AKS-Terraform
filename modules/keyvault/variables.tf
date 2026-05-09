variable keyvault_name {
  description = "Name of the Key Vault"
  type        = string
}

variable location {
  description = "Azure region where the resources will be created"
  type        = string
}

variable resource_group_name {
  description = "Name of the resource group where the Key Vault will be created"
  type        = string
}

variable service_principal_name {
  type        = string
}

variable service_principal_object_id {}

variable service_principal_tenant_id {}