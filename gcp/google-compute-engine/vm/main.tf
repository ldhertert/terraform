terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.18.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region = var.region
}

resource "google_compute_instance" "default" {
  name         = var.name
  description  = var.description
  machine_type = var.machine_type
  zone         = var.zone

  tags = var.tags

  boot_disk {
    initialize_params {
      image = var.boot_image
    }
  }

  network_interface {
    network = var.network_name

    access_config {
      // Ephemeral public IP
    }
  }

  metadata_startup_script = var.startup_script

  service_account {
    scopes = var.scopes
  }
}