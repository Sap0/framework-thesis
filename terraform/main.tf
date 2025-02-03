terraform {
  backend "azurerm" {
    resource_group_name  = "myResourceGroup"
    storage_account_name = "mystorageaccount"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

# Resource Group creation
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Random name for ACR
resource "random_string" "acr_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Azure Container Registry creation
resource "azurerm_container_registry" "acr" {
  name                = "acr${random_string.acr_suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = true
}

# Create AKS identity
resource "azurerm_user_assigned_identity" "aks_identity" {
  name                = "aks-identity"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

# Role assignments to allow aks to pull image from acr
resource "azurerm_role_assignment" "aks_network" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id
}

resource "azurerm_role_assignment" "aks_acr" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id
}

resource "azurerm_role_assignment" "aks_acr_manage_id" {
  scope                = azurerm_user_assigned_identity.aks_identity.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id
}

# AKS cluster creation
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.aks_dns_prefix
  role_based_access_control_enabled = true

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = "Standard_B2als_v2"
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  kubelet_identity {
    object_id                 = azurerm_user_assigned_identity.aks_identity.principal_id
    client_id                 = azurerm_user_assigned_identity.aks_identity.client_id
    user_assigned_identity_id = azurerm_user_assigned_identity.aks_identity.id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_identity.id]
  }

  tags = {
    environment = "dev"
  }

  depends_on = [azurerm_role_assignment.aks_network, azurerm_role_assignment.aks_acr]
}
