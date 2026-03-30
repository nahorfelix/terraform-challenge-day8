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

# Just demonstrate the module structure works
module "node_app" {
  source = "../../../../modules/services/node-app-cluster"

  cluster_name  = "node-app-demo"
  instance_type = "t3.micro"
  min_size      = 0  # Set to 0 to avoid EC2 launch issues
  max_size      = 0  # Set to 0 to avoid EC2 launch issues
  server_port   = 8080
}

output "alb_dns_name" {
  value       = module.node_app.alb_dns_name
  description = "The domain name of the load balancer"
}

output "asg_name" {
  value       = module.node_app.asg_name
  description = "The name of the Auto Scaling Group"
}