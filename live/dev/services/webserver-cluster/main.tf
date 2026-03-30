terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "webserver_cluster" {
  source = "github.com/nahorfelix/terraform-challenge-day8//modules/services/webserver-cluster?ref=v0.0.2"

  cluster_name      = "webservers-dev"
  instance_type     = "t3.micro"
  min_size          = 1
  max_size          = 4
  server_port       = 8080
  enable_autoscaling = true   # Enable autoscaling in dev to test v0.0.2 features
  custom_tags = {
    Environment = "development"
    Project     = "terraform-challenge"
    Version     = "v0.0.2"
  }
}

output "alb_dns_name" {
  value       = module.webserver_cluster.alb_dns_name
  description = "The domain name of the load balancer"
}

output "asg_name" {
  value       = module.webserver_cluster.asg_name
  description = "The name of the Auto Scaling Group"
}