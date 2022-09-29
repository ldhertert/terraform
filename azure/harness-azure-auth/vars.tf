variable "email" {
  description = "Your email address"
  type        = string
  default = "user@email.com"
}

variable "environment" {
  type    = string
  default = "local"
}

variable "app_registration_name" {
  description = "The name for the app registration"
  type        = string
  default     = "harness-app"
}

variable "azure_credential_name" {
  description = "The name for the azure credentials"
  type        = string
  default     = "Azure Client Secret"
}

variable "secret_manager" {
  description = "The secret manager that should be used to store that azure credentials."
  type = string
  default = "harnessSecretManager"
}