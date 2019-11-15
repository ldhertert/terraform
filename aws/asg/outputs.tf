output "name" {
    value = "${var.name}"
}

output "region" {
  value = "${local.region}"
}

output "launch_config_id" {
  description = "The ID of the launch configuration"
  value       = module.asg.this_launch_configuration_id
}

output "asg_id" {
  description = "The autoscaling group id"
  value       = module.asg.this_autoscaling_group_id
}

output "asg_az" {
  description = "The availability zones of the autoscale group"
  value       = module.asg.this_autoscaling_group_availability_zones
}

output "asg_vpc_zone" {
  description = "The VPC zone identifier"
  value       = module.asg.this_autoscaling_group_vpc_zone_identifier
}

output "asg_load_balancers" {
  description = "The load balancer names associated with the autoscaling group"
  value       = module.asg.this_autoscaling_group_load_balancers
}

output "asg_target_group_arns" {
  description = "List of Target Group ARNs that apply to this AutoScaling Group"
  value       = module.asg.this_autoscaling_group_target_group_arns
}

output "elb_dns_name" {
  description = "DNS Name of the ELB"
  value       = module.elb.this_elb_dns_name
}

output "elb_id" {
  value       = module.elb.this_elb_id
}
