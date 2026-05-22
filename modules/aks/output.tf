output "config" {
    value = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
  
}