provider "azurerm" {
  features {}
  subscription_id = "dc689f67-6b1e-4c7c-990a-7651be51e9e8" # to automate
}

terraform {
  backend "azurerm" {
    resource_group_name  = "myResourceGroup"
    storage_account_name = "mystorageaccount"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

# Creazione del Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Creazione di un Azure Container Registry (ACR)
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

# Creazione del cluster AKS
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.aks_dns_prefix

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = "Standard_B2als_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "dev"
  }
}

# Output delle credenziali di accesso per il cluster AKS
output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw
  sensitive = true
}
