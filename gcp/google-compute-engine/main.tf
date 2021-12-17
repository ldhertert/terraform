provider "google" {
  project = "sales-209522"
  region  = "us-central1"
  zone    = "us-central1-f"
}
data "google_client_config" "provider" {}


resource "random_uuid" "uuid" {}

locals {
  kubeconfig_path = "/tmp/${var.cluster_name}-${random_uuid.uuid.result}.kubeconfig"
  cluster_name = "${var.prefix}${var.cluster_name}${var.suffix}"
  private_key = file(var.ssh_private_key_path)
}

resource "google_compute_firewall" "k3s-firewall" {
  name    = "${local.cluster_name}-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["6443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["k3s"]
}

resource "google_compute_instance" "k3s_master_instance" {
  name         = "${local.cluster_name}-master"
  machine_type = var.machine_type
  tags         = ["k3s", "http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = var.machine_image
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = self.network_interface[0].access_config[0].nat_ip
      timeout     = "500s"
      user        = var.ssh_username
      private_key = local.private_key
    }

    inline = [
      "echo 'Waiting for SSH to be ready...'",
    ]
  }

  provisioner "local-exec" {

    command = <<EOT
            sudo apt-get update
            sudo apt-get install -y \
                git \
                wget

            # Install docker
            curl -fsSL https://get.docker.com | sudo sh
            sudo usermod -aG docker $USER
            sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
            sudo chmod +x /usr/local/bin/docker-compose

            # Install k3s
            k3sup install \
                --ip ${self.network_interface[0].access_config[0].nat_ip} \
                --ssh-key ${var.ssh_private_key_path} \
                --user ${var.ssh_username} \
                --local-path ${local.kubeconfig_path} \
                --k3s-extra-args '--no-deploy traefik'

        EOT
  }

  depends_on = [
    google_compute_firewall.k3s-firewall,
  ]
}

data "local_file" "kubeconfig" {
    filename = local.kubeconfig_path
    depends_on = [ google_compute_instance.k3s_master_instance ]
}
