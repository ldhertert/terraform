variable "name" {
  description = "The name of this asg"
  default     = "harness"
}

variable "vpc_id" {
  description = ""
  default     = ""
}

variable "max_size" {
  default = 0
}

variable "min_size" {
  default = 0
}

variable "desired_capacity" {
  default = 0
}

variable "instance_security_groups" {
  default = []
}

variable "subnet_ids" {
  default = []
}

variable "key_name" {
  default = ""
}

variable "image_id" {
  default = ""
}

variable "instance_type" {
  default = "t2.micro"
}

variable "lb_security_groups" {
  default = []
}

variable "lb_listen_port" {
  default = 80
}

variable "lb_listen_protocol" {
  default = "HTTP"
}

variable "instance_port" {
  default = "80"
}

variable "instance_health_path" {
  default = "/"
}



# Other variables
# tags
