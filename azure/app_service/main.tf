terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.24.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  common_tags = {
    Component   = "azure-app-service-infra"
    Environment = "${var.environment}"
    Owner       = "${var.email}"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.name}-rg"
  location = var.location
}

resource "azurerm_service_plan" "plan" {
  name                = "${var.name}-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = var.os
  sku_name            = var.sku

  tags = local.common_tags
}

resource "azurerm_linux_web_app" "app" {
  name                = var.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {
    application_stack {
      docker_image     = var.docker_image
      docker_image_tag = var.docker_tag
    }
  }

  tags = local.common_tags
}

resource "azurerm_linux_web_app_slot" "slot" {
  name           = "${var.name}-staging"
  app_service_id = azurerm_linux_web_app.app.id

  site_config {
    application_stack {
      docker_image     = var.docker_image
      docker_image_tag = var.docker_tag
    }
  }

  tags = local.common_tags
}
