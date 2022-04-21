
data "azurerm_resource_group" "rg" {
  name = var.resource_group
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "${var.name}-cluster"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  dns_prefix          = "${var.name}-cluster"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
  sensitive = true
}

output "cluster_identity" {
  value      = azurerm_kubernetes_cluster.aks_cluster.kubelet_identity[0].object_id
}
