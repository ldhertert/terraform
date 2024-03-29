output "application_id" {
  value = azuread_application.harness_app_registration.application_id
}

output "client_secret" {
  value     = azuread_application_password.client_secret.value
  sensitive = true
}

output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}