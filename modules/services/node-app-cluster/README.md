# Node App Cluster Module

A Terraform module that creates a highly available, auto-scaling web application cluster on AWS. This module provisions all the necessary infrastructure components to run a containerized or simple web application with automatic load balancing and scaling capabilities.

## Architecture Components

This module creates a complete web application infrastructure stack:

### Load Balancing Layer
- **Application Load Balancer (ALB)** - Handles incoming HTTP traffic and distributes it across healthy instances
- **Target Group** - Defines health check parameters and routing rules for backend instances
- **Listener** - Configures how the load balancer processes incoming requests

### Compute Layer  
- **Launch Template** - Defines the blueprint for EC2 instances including AMI, instance type, and user data
- **Auto Scaling Group** - Manages the desired number of instances and automatically replaces unhealthy ones
- **Dynamic AMI Selection** - Automatically uses the latest Amazon Linux 2 AMI for security patches

### Security Layer
- **ALB Security Group** - Controls inbound traffic from the internet (HTTP on port 80)
- **Instance Security Group** - Restricts instance access to only accept traffic from the load balancer
- **Least Privilege Access** - Each component can only communicate with necessary resources

## Usage

### Basic Implementation

```hcl
module "web_application" {
  source = "./modules/services/node-app-cluster"

  cluster_name  = "my-web-app"
  min_size      = 2
  max_size      = 10
  instance_type = "t3.small"
  server_port   = 8080
}

output "application_endpoint" {
  value = "http://${module.web_application.alb_dns_name}"
}
```

### Multi-Environment Example

```hcl
# Development Environment
module "dev_cluster" {
  source = "./modules/services/node-app-cluster"
  
  cluster_name  = "myapp-dev"
  min_size      = 1
  max_size      = 3
  instance_type = "t3.micro"
}

# Production Environment  
module "prod_cluster" {
  source = "./modules/services/node-app-cluster"
  
  cluster_name  = "myapp-prod"
  min_size      = 3
  max_size      = 20
  instance_type = "t3.medium"
}
```

## Input Variables

### Required Variables

These parameters must be provided when calling the module:

- **`cluster_name`** (string): A unique identifier used as a prefix for all resources. This helps organize resources and avoid naming conflicts when deploying multiple clusters.

- **`min_size`** (number): The minimum number of EC2 instances the Auto Scaling Group should maintain. This ensures your application always has sufficient capacity to handle baseline traffic.

- **`max_size`** (number): The maximum number of instances the Auto Scaling Group can scale up to during high traffic periods. This provides an upper bound for cost control.

### Optional Variables

These parameters have sensible defaults but can be customized:

- **`instance_type`** (string, default: "t3.micro"): The EC2 instance type for your application servers. Choose based on your performance and cost requirements.

- **`app_port`** (number, default: 8080): The port your application listens on for HTTP requests. Most web applications use 8080 for development or 80/443 for production.

- **`server_port`** (number, default: 8080): The port used for health checks. Usually the same as app_port unless your application has a dedicated health check endpoint.

## Outputs

The module exposes these values for use by calling configurations:

- **`alb_dns_name`**: The public DNS name of the Application Load Balancer. Use this to access your deployed application or configure custom domain names.

- **`asg_name`**: The name of the Auto Scaling Group. Useful for setting up CloudWatch alarms, scaling policies, or operational monitoring.

## Infrastructure Behavior

### Automatic Scaling
The Auto Scaling Group monitors instance health and automatically:
- Replaces failed instances within minutes
- Distributes instances across multiple Availability Zones for high availability
- Maintains the desired capacity between min_size and max_size

### Health Monitoring
The system performs multi-layer health checks:
- **ELB Health Checks**: Load balancer verifies instances respond to HTTP requests
- **Auto Scaling Health Checks**: Monitors EC2 instance status and replaces failed instances
- **Target Group Health Checks**: Configurable health check path, timeout, and thresholds

### Zero-Downtime Updates
The module implements several patterns for safe infrastructure updates:
- **Launch Template Versioning**: New configurations create new template versions
- **Rolling Updates**: Auto Scaling Group gradually replaces instances with new configurations  
- **Create Before Destroy**: New resources are created before old ones are terminated

## Requirements

### AWS Resources
- Default VPC with public subnets (automatically detected)
- Internet Gateway attached to the VPC
- Sufficient EC2 instance limits for your chosen instance type

### Terraform Version
- Terraform >= 1.0
- AWS Provider ~> 5.0

### AWS Permissions
The deploying user/role needs permissions for:
- EC2 (instances, launch templates, security groups)
- Auto Scaling (groups, policies)
- Elastic Load Balancing (ALBs, target groups, listeners)
- VPC (describe VPCs, subnets)

## Cost Considerations

### Instance Costs
- **t3.micro**: ~$8.50/month per instance (Free Tier eligible for first 12 months)
- **t3.small**: ~$17/month per instance  
- **t3.medium**: ~$34/month per instance

### Load Balancer Costs
- **Application Load Balancer**: ~$16/month base cost + $0.008 per LCU-hour
- **Data Transfer**: Standard AWS data transfer rates apply

### Optimization Tips
- Use smaller instance types for development environments
- Set appropriate min/max scaling limits to control costs
- Consider scheduled scaling for predictable traffic patterns

## Troubleshooting

### Common Issues

**Instance Launch Failures**
- Check AWS service quotas for your instance type
- Verify the selected instance type is available in your region's AZs
- Ensure your AWS account has sufficient EC2 limits

**Health Check Failures**  
- Verify your application starts correctly and listens on the configured port
- Check security group rules allow traffic from the load balancer
- Review the user_data script for any startup errors

**Module Not Found Errors**
- Verify the relative path in the module source is correct
- Run `terraform init` after adding or modifying module sources
- Check that all required files (main.tf, variables.tf, outputs.tf) exist in the module directory

## Examples

See the `live/` directory for complete examples of how to use this module in different environments. Each example demonstrates different configuration patterns and use cases.

---

*This module was developed as part of the 30-Day Terraform Challenge, demonstrating professional infrastructure-as-code practices and reusable module design.*