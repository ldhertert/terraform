output "server_ip" {
  value     = google_compute_instance.k3s_master_instance.network_interface[0].access_config[0].nat_ip
}

output "kubeconfig" {
  sensitive = true
  value     = data.local_file.kubeconfig.content
}

output "kubeconfig_path" {
  value     = local.kubeconfig_path
}
