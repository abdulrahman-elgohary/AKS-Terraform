variable subscription_id {
    type = string
    description = "Azure Subscription ID where the resources will be created"
}

variable rgname {
    type = string
    description = "Name of the Resource Group to be created"
}

variable location {
    type = string
    description = "Azure Region where the resources will be created"
}

variable service_principal_name {
    type = string
    description = "Name of the Service Principal to be created"
}