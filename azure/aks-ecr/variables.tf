variable "name" {
  description = "Name. Must be unique."
  type        = string
}

variable "resource_group" {
  description = "Resource group name"
  type        = string
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}