variable "email" {
  description = "Your email address"
  type        = string
}

variable "environment" {
  type    = string
  default = "local"
}

variable "name" {
  description = "Service name"
  type        = string
  default     = "harness-webapp"
}

variable "location" {
  type    = string
  default = "East Us"
}

variable "os" {
  type    = string
  default = "Linux"
}

variable "sku" {
  type    = string
  default = "S1"
}

variable "docker_image" {
  type    = string
  default = "nginx"
}

variable "docker_tag" {
  type    = string
  default = "latest"
}
