data "azurerm_resource_group" "rg" {
  name = var.resource_group
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.name}docker"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku                 = "Basic"
  tags = var.tags
}

output "id" {
  value = azurerm_container_registry.acr.id
}