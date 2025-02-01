# Output of the credentials to access kubernetes
output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}

output "acr_name" {
  value = azurerm_container_registry.acr.name
}