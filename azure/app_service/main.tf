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
