output "primary_host" {
  value = azurerm_linux_web_app.app.default_hostname
}

output "staging_host" {
  value = azurerm_linux_web_app.app.default_hostname
}
