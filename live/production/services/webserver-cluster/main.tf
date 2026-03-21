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
  source = "../../../../modules/services/webserver-cluster"

  cluster_name  = "webservers-production"
  instance_type = "t3.small"
  min_size      = 1
  max_size      = 3
  server_port   = 8080
}

output "alb_dns_name" {
  value       = module.webserver_cluster.alb_dns_name
  description = "The domain name of the load balancer"
}

output "asg_name" {
  value       = module.webserver_cluster.asg_name
  description = "The name of the Auto Scaling Group"
}