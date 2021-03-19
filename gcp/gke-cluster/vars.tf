variable "project" {
  description = "The project ID to host the cluster in"
}

variable "zone" {
  description = "The zone to host the cluster in"
  default = "us-central1-a"
}

variable "clusterName" {
  description = "The name of the cluster"
  default = "tf-ephemeral-cluster"
}

variable "credentials" {
    description = "Google Cloud Keyfile JSON"
    default = ""
}

variable "master_username" {
    description = "Username for basic authentication to the cluster"
    default = "admin"
}

variable "master_password" {
    description = "Username for basic authentication to the cluster"
}
