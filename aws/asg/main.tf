provider "aws" {
  version = "~> 2.0"
  region  = "${local.region}"
}

locals {
  region = "us-east-2"
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "in_vpc" {
  vpc_id = "${var.vpc_id != "" ? var.vpc_id : data.aws_vpc.default.id}"
}

data "aws_security_group" "default" {
  vpc_id = "${var.vpc_id != "" ? var.vpc_id : data.aws_vpc.default.id}"
  name = "default"
}

######
# Launch configuration and autoscaling group
######
module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = "${var.name}"

  # Launch configuration
  lc_name = "${var.name}-lc"

  image_id          = "${var.image_id != "" ? var.image_id : data.aws_ami.amazon-linux-2.id}"
  instance_type     = "${var.instance_type}"
  enable_monitoring = false
  enabled_metrics   = []
  key_name          = "${var.key_name}"
  load_balancers  = [module.elb.this_elb_id]
  security_groups = "${length(var.instance_security_groups) > 0 ? var.instance_security_groups : [data.aws_security_group.default.id]}"

  # Auto scaling group
  asg_name                  = "${var.name}-asg"
  vpc_zone_identifier       = "${length(var.subnet_ids) > 0 ? var.subnet_ids : data.aws_subnet_ids.in_vpc.ids}"
  health_check_type         = "EC2"
  min_size                  = "${var.min_size}"
  max_size                  = "${var.max_size}"
  desired_capacity          = "${var.desired_capacity}"
  wait_for_capacity_timeout = 0

  # tags = [
  #   {
  #     key                 = "Environment"
  #     value               = "dev"
  #     propagate_at_launch = true
  #   },
  #   {
  #     key                 = "Project"
  #     value               = "megasecret"
  #     propagate_at_launch = true
  #   },
  # ]

  # tags_as_map = {
  #   extra_tag1 = "extra_value1"
  #   extra_tag2 = "extra_value2"
  # }
}

######
# ELB
######
module "elb" {
  source = "terraform-aws-modules/elb/aws"

  name = "${var.name}-lb"

  subnets         = "${length(var.subnet_ids) > 0 ? var.subnet_ids : data.aws_subnet_ids.in_vpc.ids}"
  security_groups = "${length(var.lb_security_groups) > 0 ? var.lb_security_groups : [data.aws_security_group.default.id]}"
  internal        = false

  listener = [
    {
      instance_port     = "${var.instance_port}"
      instance_protocol = "HTTP"
      lb_port           = "${var.lb_listen_port}"
      lb_protocol       = "${var.lb_listen_protocol}"
    },
  ]

  health_check = {
    target              = "HTTP:${var.instance_port}/"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }
}
