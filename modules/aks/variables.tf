variable "location" {
  type        = string
}

variable "cluster_name" {
  type        = string
}

variable "resource_group_name" {
  type        = string
}
variable "node_pool_name" {
  type        = string
}

variable "vm_size" {
  type        = string
}

variable "client_id" {
  type        = string
}

variable "client_secret" {
  type        = string
  sensitive = true
}

variable "service_principal_name" {
  type        = string
}

variable "ssh_public_key" {
  type        = string
  default = "~/.ssh/id_rsa.pub"
}
