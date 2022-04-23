terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.18.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "gce-container" {
    source  = "terraform-google-modules/container-vm/google"
    version = "3.0.0"

    container = {
        image = var.container_image
        command = var.container_command
        env = var.container_env

        restart_policy = "Always"
    }
}

resource "google_compute_instance" "default" {
  name         = var.name
  description  = var.description
  machine_type = var.machine_type
  zone         = var.zone

  tags = var.tags

   boot_disk {
    initialize_params {
      image = module.gce-container.source_image
    }
  }

  network_interface {
    network = var.network_name

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    gce-container-declaration = module.gce-container.metadata_value
    google-logging-enabled    = "true"
    google-monitoring-enabled = "true"
  }

  labels = {
    container-vm = module.gce-container.vm_container_label
  }

  service_account {
    scopes = var.scopes
  }
}
