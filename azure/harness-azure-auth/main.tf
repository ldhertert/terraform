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

provider "azuread" {}

data "azurerm_client_config" "current" {}
data "azurerm_subscription" "primary" {}

locals {
  common_tags = {
    Component   = "azure-app-service-infra"
    Environment = "${var.environment}"
    Owner       = "${var.email}"
  }
}

resource "azuread_application" "harness_app_registration" {
  display_name = "${var.app_registration_name}"
}

resource "azuread_service_principal" "service_principal" {
  application_id = azuread_application.harness_app_registration.application_id
}

resource "azuread_application_password" "client_secret" {
  application_object_id = azuread_application.harness_app_registration.object_id
}

resource "azurerm_role_definition" "harness_app_services_deployer_role" {
  name        = "Harness App Services Deployer"
  scope       = data.azurerm_subscription.primary.id
  description = "This is a custom Harness role that enableds App Services deployments."

  permissions {
    actions = [
      "microsoft.web/sites/slots/deployments/read",
      "Microsoft.Web/sites/Read",
      "Microsoft.Web/sites/config/Read",
      "Microsoft.Web/sites/slots/config/Read",
      "microsoft.web/sites/slots/config/appsettings/read",
      "Microsoft.Web/sites/slots/*/Read",
      "Microsoft.Web/sites/slots/config/list/Action",
      "Microsoft.Web/sites/slots/stop/Action",
      "Microsoft.Web/sites/slots/start/Action",
      "Microsoft.Web/sites/slots/config/Write",
      "Microsoft.Web/sites/slots/Write",
      "microsoft.web/sites/slots/containerlogs/action",
      "Microsoft.Web/sites/config/Write",
      "Microsoft.Web/sites/slots/slotsswap/Action",
      "Microsoft.Web/sites/config/list/Action",
      "Microsoft.Web/sites/start/Action",
      "Microsoft.Web/sites/stop/Action",
      "Microsoft.Web/sites/Write",
      "microsoft.web/sites/containerlogs/action",
      "Microsoft.Web/sites/publish/Action",
      "Microsoft.Web/sites/slots/publish/Action"
    ]
  }

  assignable_scopes = [
    data.azurerm_subscription.primary.id
  ]
}

resource "azurerm_role_definition" "harness_acr_read_only_role" {
  name        = "Harness ACR Read Only"
  scope       = data.azurerm_subscription.primary.id
  description = "This is a custom Harness role that allows users to list and pull images in ACR."

  permissions {
    actions = [
      "Microsoft.ContainerRegistry/registries/pull/read",
      "Microsoft.ContainerRegistry/registries/read",
      "Microsoft.ContainerRegistry/registries/metadata/read",

    ]
  }

  assignable_scopes = [
    data.azurerm_subscription.primary.id
  ]
}

resource "azurerm_role_definition" "harness_acr_read_write_role" {
  name        = "Harness ACR Read/Write Role"
  scope       = data.azurerm_subscription.primary.id
  description = "This is a custom Harness role that allows read/write access to ACR."

  permissions {
    actions = [
      "Microsoft.ContainerRegistry/registries/pull/read",
      "Microsoft.ContainerRegistry/registries/read",
      "Microsoft.ContainerRegistry/registries/metadata/read",
      "Microsoft.ContainerRegistry/registries/push/write",
      "Microsoft.ContainerRegistry/registries/write",
      "Microsoft.ContainerRegistry/registries/delete",
      "Microsoft.ContainerRegistry/registries/importImage/action",
      "Microsoft.ContainerRegistry/registries/artifacts/delete",
      "Microsoft.ContainerRegistry/registries/metadata/read",
      "Microsoft.ContainerRegistry/registries/metadata/write",
      "Microsoft.ContainerRegistry/registries/sign/write"
    ]
  }

  assignable_scopes = [
    data.azurerm_subscription.primary.id
  ]
}

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