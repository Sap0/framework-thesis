variable "resource_group_name" {
  description = "Resource Group Name"
  default     = "myResourceGroup"
}

variable "location" {
  description = "Azure Region"
  default     = "East US"
}

variable "aks_name" {
  description = "AKS Cluster name"
  default     = "myAKSCluster"
}

variable "aks_dns_prefix" {
  description = "AKS Cluster DNS Prefix"
  default     = "myaks"
}

variable "node_count" {
  description = "AKS cluster node counts"
  default     = 1
}