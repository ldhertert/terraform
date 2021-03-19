provider "google" {
  credentials = var.credentials
}

resource "google_container_cluster" "primary" {
  name               = var.clusterName
  location           = var.zone
  project            = var.project
  initial_node_count = 1
  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  # enable basic auth
  master_auth {
    username = var.master_username
    password = var.master_password
  }
}
