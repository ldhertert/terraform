terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group
}

resource "azurerm_service_plan" "app_service_plan" {
  name                = "${var.name}-service-plan"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B3"
  tags                = var.tags
}

resource "azurerm_linux_web_app" "app_service" {
  name                = "${var.name}-appservice"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.app_service_plan.id

  site_config {}
}
