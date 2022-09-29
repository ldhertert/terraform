terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.24.0"
    }

   azuread = {
     source  = "hashicorp/azuread"
     version = "2.28.1"
   }

   harness = {
      source = "harness/harness"
      version = "0.5.3"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "primary" {}

locals {
  common_tags = {
    Environment = "${var.environment}"
    Owner       = "${var.email}"
  }
}

resource "random_pet" "random" {}

resource "azuread_application" "harness_app_registration" {
  display_name = "${var.app_registration_name}_${random_pet.random.id}"
}

resource "azuread_service_principal" "service_principal" {
  application_id = azuread_application.harness_app_registration.application_id
}

resource "azuread_application_password" "client_secret" {
  application_object_id = azuread_application.harness_app_registration.object_id
}

resource "azurerm_role_assignment" "service_principal_app_services_deployer_role" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = var.role_name
  principal_id         = azuread_service_principal.service_principal.object_id
}


/*
resource "azurerm_role_assignment" "service_principal_app_services_deployer_role" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = azurerm_role_definition.harness_app_services_deployer_role.name
  principal_id         = azuread_service_principal.service_principal.object_id
}

resource "azurerm_role_assignment" "service_principal_acr_read_write_role" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = azurerm_role_definition.harness_acr_read_write_role.name
  principal_id         = azuread_service_principal.service_principal.object_id
}
*/
