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

module "cluster" {
  source = "./modules/aks"

  name           = "azuretf"
  resource_group = "harness-automation"
  tags = {
    env        = "dev"
    created_by = "luke"
  }
}


module "registry" {
    source  = "./modules/acr"

    name = "azuretf"
    resource_group = "harness-automation"
    tags = {
        env = "dev"
        created_by = "luke"
    }
}

resource "azurerm_role_assignment" "aks_acr_role" {
  principal_id                     = module.cluster.cluster_identity
  role_definition_name             = "AcrPull"
  scope                            = module.registry.id
  skip_service_principal_aad_check = true
}

module "webapp" {
  source = "./modules/app_service"

  name           = "azuretf"
  resource_group = "harness-automation"
  tags = {
    env        = "dev"
    created_by = "luke"
  }
}

module "vault" {
  source = "./modules/azure_key_vault"

  name           = "azuretf"
  resource_group = "harness-automation"
  tags = {
    env        = "dev"
    created_by = "luke"
  }
}

