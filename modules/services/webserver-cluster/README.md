# Web Server Cluster Module

This module creates a scalable web server cluster using AWS Auto Scaling Groups and Application Load Balancer.

## Architecture

- **Auto Scaling Group**: Manages EC2 instances across multiple AZs
- **Application Load Balancer**: Distributes traffic across healthy instances
- **Launch Configuration**: Defines instance template with user data script
- **Security Groups**: Controls network access for instances and ALB
- **Target Group**: Health checks and routing configuration

## Usage

```hcl
module "webserver_cluster" {
  source = "../../../../modules/services/webserver-cluster"

  cluster_name  = "webservers-dev"
  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 4
  server_port   = 8080
}

output "alb_dns_name" {
  value = module.webserver_cluster.alb_dns_name
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_name | The name to use for all cluster resources | `string` | n/a | yes |
| min_size | Minimum number of EC2 instances in the ASG | `number` | n/a | yes |
| max_size | Maximum number of EC2 instances in the ASG | `number` | n/a | yes |
| instance_type | EC2 instance type for the cluster | `string` | `"t2.micro"` | no |
| server_port | Port the server uses for HTTP | `number` | `8080` | no |

## Outputs

| Name | Description |
|------|-------------|
| alb_dns_name | The domain name of the load balancer |
| asg_name | The name of the Auto Scaling Group |
| alb_zone_id | The hosted zone ID of the load balancer |
| security_group_id | The ID of the ALB security group |

## Requirements

- AWS Provider
- Default VPC with public subnets
- Internet Gateway configured

## Notes

- Instances serve a simple HTML page with cluster name
- Health checks are performed on the root path "/"
- All instances are launched in the default VPC across available subnets
- Security groups follow least-privilege principle