// The intent is to eventually have granular roles that have limited permission sets based on what customers
// want to do.  For not I'm simply going to use one of the overly broad out of the box roles.


# resource "azurerm_role_definition" "harness_app_services_deployer_role" {
#   name        = "Harness App Services Deployer"
#   scope       = data.azurerm_subscription.primary.id
#   description = "This is a custom Harness role that enableds App Services deployments."

#   permissions {
#     actions = [
#       "microsoft.web/sites/slots/deployments/read",
#       "Microsoft.Web/sites/Read",
#       "Microsoft.Web/sites/config/Read",
#       "Microsoft.Web/sites/slots/config/Read",
#       "microsoft.web/sites/slots/config/appsettings/read",
#       "Microsoft.Web/sites/slots/*/Read",
#       "Microsoft.Web/sites/slots/config/list/Action",
#       "Microsoft.Web/sites/slots/stop/Action",
#       "Microsoft.Web/sites/slots/start/Action",
#       "Microsoft.Web/sites/slots/config/Write",
#       "Microsoft.Web/sites/slots/Write",
#       "microsoft.web/sites/slots/containerlogs/action",
#       "Microsoft.Web/sites/config/Write",
#       "Microsoft.Web/sites/slots/slotsswap/Action",
#       "Microsoft.Web/sites/config/list/Action",
#       "Microsoft.Web/sites/start/Action",
#       "Microsoft.Web/sites/stop/Action",
#       "Microsoft.Web/sites/Write",
#       "microsoft.web/sites/containerlogs/action",
#       "Microsoft.Web/sites/publish/Action",
#       "Microsoft.Web/sites/slots/publish/Action",
#       "Microsoft.Resources/subscriptions/resourceGroups/read",
#       "Microsoft.Resources/subscriptions/resourcegroups/resources/read"
#     ]
#   }

#   assignable_scopes = [
#     data.azurerm_subscription.primary.id
#   ]
# }

# resource "azurerm_role_definition" "harness_acr_read_only_role" {
#   name        = "Harness ACR Read Only"
#   scope       = data.azurerm_subscription.primary.id
#   description = "This is a custom Harness role that allows users to list and pull images in ACR."

#   permissions {
#     actions = [
#       "Microsoft.ContainerRegistry/registries/pull/read",
#       "Microsoft.ContainerRegistry/registries/read",
#       "Microsoft.ContainerRegistry/registries/metadata/read",

#     ]
#   }

#   assignable_scopes = [
#     data.azurerm_subscription.primary.id
#   ]
# }

# resource "azurerm_role_definition" "harness_acr_read_write_role" {
#   name        = "Harness ACR Read/Write Role"
#   scope       = data.azurerm_subscription.primary.id
#   description = "This is a custom Harness role that allows read/write access to ACR."

#   permissions {
#     actions = [
#       "Microsoft.ContainerRegistry/registries/pull/read",
#       "Microsoft.ContainerRegistry/registries/read",
#       "Microsoft.ContainerRegistry/registries/metadata/read",
#       "Microsoft.ContainerRegistry/registries/push/write",
#       "Microsoft.ContainerRegistry/registries/write",
#       "Microsoft.ContainerRegistry/registries/delete",
#       "Microsoft.ContainerRegistry/registries/importImage/action",
#       "Microsoft.ContainerRegistry/registries/artifacts/delete",
#       "Microsoft.ContainerRegistry/registries/metadata/read",
#       "Microsoft.ContainerRegistry/registries/metadata/write",
#       "Microsoft.ContainerRegistry/registries/sign/write"
#     ]
#   }

#   assignable_scopes = [
#     data.azurerm_subscription.primary.id
#   ]
# }

