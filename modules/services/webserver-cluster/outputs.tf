output "alb_dns_name" {
  value       = aws_lb.example.dns_name
  description = "The domain name of the load balancer"
}

output "asg_name" {
  value       = aws_autoscaling_group.example.name
  description = "The name of the Auto Scaling Group"
}

output "alb_zone_id" {
  value       = aws_lb.example.zone_id
  description = "The hosted zone ID of the load balancer"
}

output "security_group_id" {
  value       = aws_security_group.alb.id
  description = "The ID of the ALB security group"
}