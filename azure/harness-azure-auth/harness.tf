/*
provider "harness" {
  account_id = "KaZNXe69Qzm8KOo8bGCwwg"
}

resource "harness_platform_secret_text" "azure_cloud_provider_client_secret" {
  name = var.azure_credential_name
  identifier = replace(lower(var.azure_credential_name), " ", "_")

  secret_manager_identifier = var.secret_manager

  value_type = "Inline"
  value      = azuread_application_password.client_secret.value
  lifecycle {
    ignore_changes = [
      value,
    ]
  }
}
*/