output "instance_name" {
  description = "The deployed instance name"
  value       = google_compute_instance.default.name
}

output "ipv4" {
  description = "The public IP address of the deployed instance"
  value       = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}