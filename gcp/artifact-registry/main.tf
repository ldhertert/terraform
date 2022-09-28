provider "google" {
  project = "${var.project}"
  region = "${var.region}"
}

resource "google_artifact_registry_repository" "my-repo" {
  location      = "${var.region}"
  repository_id = "${var.repository_name}"
  description   = "Name of the repository resource"
  format        = "DOCKER"
}

variable "project" {
  type = string
  default = "sales-209522"
}

variable "region" {
  type = string
  default = "us-central1"
}

variable "repository_name" {
  type = string
  default = "luke-gar-docker"
}