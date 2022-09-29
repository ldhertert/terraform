variable "email" {
  description = "Your email address"
  type        = string
  default = "user@email.com"
}

variable "environment" {
  type    = string
  default = "unknown"
}

variable "app_registration_name" {
  description = "The name for the app registration"
  type        = string
  default     = "harness_app"
}

variable "role_name" {
  description = "The role to assign to the service principle"
  type        = string
  default     = "Contributor"
}