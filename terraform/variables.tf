variable "resource_group_name" {
  description = "Il nome del resource group"
  default     = "myResourceGroup"
}

variable "location" {
  description = "La regione Azure in cui creare le risorse"
  default     = "East US"
}

variable "acr_name" {
  description = "Nome del container registry"
  default     = "myacrname"
}

variable "aks_name" {
  description = "Nome del cluster AKS"
  default     = "myAKSCluster"
}

variable "aks_dns_prefix" {
  description = "Prefisso DNS per il cluster AKS"
  default     = "myaks"
}

variable "node_count" {
  description = "Numero di nodi nel cluster AKS"
  default     = 2
}
