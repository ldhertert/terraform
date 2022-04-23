variable "project_id" {
  type        = string
  description = "The project ID to deploy resources into"
}

variable "region" {
  type        = string
  description = "Region where the instances should be created."
  default     = ""
}

variable "zone" {
  type        = string
  description = "Zone where the instances should be created."
  default     = ""
}

variable "name" {
  type        = string
  description = "The desired name to assign to the deployed instance"
  default     = "google-compute-vm"
  nullable    = true
}

variable "description" {
  type        = string
  description = "A description of this instance"
  default     = ""
}

variable "machine_type" {
  type        = string
  description = "The instance type of the VM"
  default     = "e2-medium"
}

variable "tags" {
  type        = list(string)
  description = "Tags that contain metadata about this resource"
  default     = []
}


variable "boot_image" {
  type        = string
  description = "The VM image to use as the boot image"
  default     = "debian-cloud/debian-10"
}

variable "network_name" {
  type        = string
  description = "The the name of the network to be attached"
  default     = "default"
}

variable "startup_script" {
  type        = string
  description = "A shell script that is executed on machine start."
  default     = ""
}

variable "scopes" {
  type        = list(string)
  description = "A list of service scopes. "
  default     = ["cloud-platform"]
}
