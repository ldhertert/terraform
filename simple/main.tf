variable "name" {
  description = "A name"
}

output "nameOut" {
    value = "${var.name}"
}
