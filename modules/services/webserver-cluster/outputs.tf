# GOTCHA FIX 3: Provide granular outputs to avoid unnecessary dependencies
output "alb_dns_name" {
  value       = aws_lb.example.dns_name
  description = "The domain name of the load balancer"
}

output "alb_arn" {
  value       = aws_lb.example.arn
  description = "The ARN of the load balancer"
}

output "alb_zone_id" {
  value       = aws_lb.example.zone_id
  description = "The hosted zone ID of the load balancer"
}

output "asg_name" {
  value       = aws_autoscaling_group.example.name
  description = "The name of the Auto Scaling Group"
}

output "asg_arn" {
  value       = aws_autoscaling_group.example.arn
  description = "The ARN of the Auto Scaling Group"
}

output "launch_template_id" {
  value       = aws_launch_template.example.id
  description = "The ID of the launch template"
}

output "target_group_arn" {
  value       = aws_lb_target_group.asg.arn
  description = "The ARN of the target group"
}

output "alb_security_group_id" {
  value       = aws_security_group.alb.id
  description = "The ID of the ALB security group"
}

output "instance_security_group_id" {
  value       = aws_security_group.instance.id
  description = "The ID of the instance security group"
}

output "vpc_id" {
  value       = data.aws_vpc.default.id
  description = "The ID of the VPC where resources are created"
}

output "subnet_ids" {
  value       = data.aws_subnets.default.ids
  description = "The IDs of the subnets where resources are created"
}