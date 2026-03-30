output "alb_dns_name" {
  value       = aws_lb.app_lb.dns_name
  description = "The public endpoint for the application"
}

output "asg_name" {
  value       = aws_autoscaling_group.app_asg.name
  description = "The name of the ASG for scaling policies"
}