output "primary_host" {
  value = azurerm_linux_web_app.app.default_hostname
}

output "staging_host" {
  value = azurerm_linux_web_app.app.default_hostname
}

output "app_id" {
  value = azurerm_linux_web_app.app.id
}

output "app_name" {
  value = azurerm_linux_web_app.app.name
}

output "primary_slot_name" {
  value = azurerm_linux_web_app.app.name
}

output "staging_slot_name" {
  value = azurerm_linux_web_app_slot.slot.name
}