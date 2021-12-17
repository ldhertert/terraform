variable "project" {
  type = string
  default = ""
}

variable "region" {
  type = string
  default = ""
}

variable "zone" {
  type = string
  default = ""
}

variable "cluster_name" {
  type = string
  default = "k3s"
}

variable "prefix" {
  type = string
  default = ""
}

variable "suffix" {
  type = string
  default = ""
}

variable "ssh_username" {
  type = string
  default = "lukehertert"
}

variable "ssh_private_key_path" {
  type = string
  default = "~/.ssh/google_compute_engine"
}

variable "machine_image" {
  type = string
  default = "debian-cloud/debian-11"
}

variable "machine_type" {
  type = string
  default = "e2-standard-2"
}
