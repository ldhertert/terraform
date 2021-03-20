provider "google" {
  credentials = var.credentials
}

resource "google_container_cluster" "primary" {
  name               = var.clusterName
  location           = var.zone
  project            = var.project
  initial_node_count = 3

  # Note: I was unable to get a healthy cluster in GKE with basic auth enabled on any master version above 1.16
  min_master_version = "1.16"

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }

  # enable basic auth
  master_auth {
    username = var.master_username
    password = var.master_password
  }
}
