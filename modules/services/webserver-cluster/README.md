# Webserver Cluster Module

A production-ready Terraform module that creates a highly available, auto-scaling web application cluster on AWS. This module provisions all the necessary infrastructure components to run web applications with automatic load balancing, scaling capabilities, and comprehensive monitoring.

## 🚨 Module Gotchas and Best Practices

This module addresses the three most common Terraform module gotchas:

### 1. File Path Resolution
**Problem**: Relative file paths in modules are resolved from where `terraform` is run, not from the module directory.
**Solution**: Always use `path.module` for files within the module.

```hcl
# ❌ BROKEN - path resolved from calling directory
user_data = templatefile("./user-data.sh", {...})

# ✅ CORRECT - path resolved from module directory  
user_data = templatefile("${path.module}/user-data.sh", {...})
```

### 2. Inline Blocks vs Separate Resources
**Problem**: Mixing inline blocks and separate resources for the same configuration causes conflicts.
**Solution**: Use separate resources for flexibility, especially in modules.

```hcl
# ❌ BROKEN - inline blocks prevent callers from adding rules
resource "aws_security_group" "example" {
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  }
}

# ✅ CORRECT - separate resources allow extension
resource "aws_security_group" "example" {
  name = "example-sg"
}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.example.id
}
```

### 3. Module Output Dependencies
**Problem**: Referencing module outputs in `depends_on` makes Terraform treat the entire module as a dependency.
**Solution**: Provide granular outputs for specific resources.

```hcl
# ❌ PROBLEMATIC - entire module becomes a dependency
output "everything" {
  value = {
    alb_dns = aws_lb.example.dns_name
    asg_name = aws_autoscaling_group.example.name
  }
}

# ✅ BETTER - granular outputs for specific dependencies
output "alb_dns_name" {
  value = aws_lb.example.dns_name
}

output "asg_name" {
  value = aws_autoscaling_group.example.name
}
```

## 🏗️ Architecture Components

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
- **Security Group Rules** - Separate resources for maximum flexibility and extensibility

### Monitoring and Scaling (v0.0.2+)
- **CloudWatch Alarms** - CPU-based monitoring for automatic scaling decisions
- **Auto Scaling Policies** - Scale up/down policies with configurable cooldown periods
- **Metric Collection** - Comprehensive monitoring of instance and application health

## 📦 Module Versions

### v0.0.1 (Stable - Recommended for Production)
- Core infrastructure with gotcha fixes
- Manual scaling only (autoscaling disabled by default)
- Stable baseline for production workloads
- Comprehensive security group rules as separate resources

### v0.0.2 (Latest - Recommended for Development)
- **BREAKING CHANGE**: `enable_autoscaling` defaults to `true`
- Enhanced auto scaling with CloudWatch integration
- CPU-based scaling policies and alarms
- Additional outputs for scaling policy ARNs

## 🚀 Usage Examples

### Basic Usage (Pinned to Stable Version)
```hcl
module "webserver_cluster" {
  source = "github.com/nahorfelix/terraform-challenge-day8//modules/services/webserver-cluster?ref=v0.0.1"

  cluster_name  = "my-web-app"
  instance_type = "t3.micro"
  min_size      = 2
  max_size      = 6
  server_port   = 8080
}

output "application_url" {
  value = "http://${module.webserver_cluster.alb_dns_name}"
}
```

### Advanced Usage with Custom Tags (Latest Version)
```hcl
module "webserver_cluster" {
  source = "github.com/nahorfelix/terraform-challenge-day8//modules/services/webserver-cluster?ref=v0.0.2"

  cluster_name       = "production-web"
  instance_type      = "t3.medium"
  min_size           = 3
  max_size           = 20
  server_port        = 8080
  enable_autoscaling = true

  custom_tags = {
    Environment = "production"
    Project     = "web-application"
    Team        = "platform"
    CostCenter  = "engineering"
  }
}
```

### Multi-Environment Strategy
```hcl
# Development - Use latest features
module "dev_cluster" {
  source = "github.com/nahorfelix/terraform-challenge-day8//modules/services/webserver-cluster?ref=v0.0.2"
  
  cluster_name       = "webservers-dev"
  instance_type      = "t3.micro"
  min_size           = 1
  max_size           = 4
  enable_autoscaling = true
}

# Production - Pin to stable version
module "prod_cluster" {
  source = "github.com/nahorfelix/terraform-challenge-day8//modules/services/webserver-cluster?ref=v0.0.1"
  
  cluster_name       = "webservers-prod"
  instance_type      = "t3.medium"
  min_size           = 3
  max_size           = 10
  enable_autoscaling = false  # Explicit for v0.0.1 compatibility
}
```

## 📋 Input Variables

### Required Variables

| Name | Description | Type | Example |
|------|-------------|------|---------|
| `cluster_name` | Unique identifier for all cluster resources | `string` | `"my-web-app"` |
| `min_size` | Minimum number of EC2 instances in the ASG | `number` | `2` |
| `max_size` | Maximum number of EC2 instances in the ASG | `number` | `10` |

### Optional Variables

| Name | Description | Type | Default | Version |
|------|-------------|------|---------|---------|
| `instance_type` | EC2 instance type for the cluster | `string` | `"t3.micro"` | v0.0.1+ |
| `server_port` | Port the server uses for HTTP | `number` | `8080` | v0.0.1+ |
| `enable_autoscaling` | Whether to enable auto scaling policies | `bool` | `false` (v0.0.1), `true` (v0.0.2+) | v0.0.1+ |
| `custom_tags` | Custom tags to apply to all resources | `map(string)` | `{}` | v0.0.1+ |

## 📤 Outputs

### Core Outputs (Available in all versions)

| Name | Description | Use Case |
|------|-------------|----------|
| `alb_dns_name` | DNS name of the Application Load Balancer | Access the deployed application |
| `alb_arn` | ARN of the load balancer | Route 53 alias records, WAF integration |
| `alb_zone_id` | Hosted zone ID of the load balancer | Route 53 alias records |
| `asg_name` | Name of the Auto Scaling Group | CloudWatch alarms, scaling policies |
| `asg_arn` | ARN of the Auto Scaling Group | IAM policies, notifications |
| `target_group_arn` | ARN of the target group | Additional listeners, path-based routing |
| `alb_security_group_id` | ID of the ALB security group | Additional ingress rules |
| `instance_security_group_id` | ID of the instance security group | Database access rules |

### Enhanced Outputs (v0.0.2+)

| Name | Description | Use Case |
|------|-------------|----------|
| `autoscaling_enabled` | Whether autoscaling policies are enabled | Conditional resource creation |
| `scale_up_policy_arn` | ARN of the scale up policy | Custom CloudWatch alarms |
| `scale_down_policy_arn` | ARN of the scale down policy | Custom CloudWatch alarms |

## ⚙️ Infrastructure Behavior

### Automatic Scaling (v0.0.2+)
When `enable_autoscaling = true`, the module creates:
- **Scale Up Policy**: Adds 1 instance when CPU > 80% for 4 minutes
- **Scale Down Policy**: Removes 1 instance when CPU < 10% for 4 minutes
- **Cooldown Period**: 5 minutes between scaling actions to prevent thrashing

### Health Monitoring
- **ELB Health Checks**: HTTP requests to `/` every 30 seconds
- **Healthy Threshold**: 2 consecutive successful checks
- **Unhealthy Threshold**: 2 consecutive failed checks
- **Timeout**: 5 seconds per check

### Security Model
- **Internet → ALB**: Port 80 from anywhere (0.0.0.0/0)
- **ALB → Instances**: Configured server port from ALB security group only
- **Instances → Internet**: All outbound traffic allowed for updates and external APIs

## 🔧 Version Migration Guide

### Upgrading from v0.0.1 to v0.0.2

**Breaking Change**: `enable_autoscaling` now defaults to `true`

```hcl
# To maintain v0.0.1 behavior in v0.0.2
module "webserver_cluster" {
  source = "github.com/nahorfelix/terraform-challenge-day8//modules/services/webserver-cluster?ref=v0.0.2"
  
  # ... other variables ...
  enable_autoscaling = false  # Explicit override
}
```

**New Features Available**:
- Automatic CPU-based scaling
- CloudWatch alarms and monitoring
- Enhanced outputs for scaling policies

## 📊 Cost Considerations

### Instance Costs (us-east-1)
- **t3.micro**: ~$8.50/month (Free Tier eligible)
- **t3.small**: ~$17/month  
- **t3.medium**: ~$34/month

### Additional AWS Services
- **Application Load Balancer**: ~$16/month + $0.008 per LCU-hour
- **CloudWatch Alarms** (v0.0.2+): $0.10 per alarm per month
- **Data Transfer**: Standard AWS rates apply

### Cost Optimization Tips
- Use `t3.micro` for development environments
- Set appropriate `min_size` and `max_size` limits
- Monitor CloudWatch costs with many alarms
- Consider scheduled scaling for predictable workloads

## 🔒 Security Best Practices

### Network Security
- Security groups implement least-privilege access
- Instances only accept traffic from the load balancer
- All security rules are separate resources for extensibility

### Resource Tagging
- All resources support custom tags via `custom_tags` variable
- Default tags include resource names and purposes
- Tags propagate to Auto Scaling Group instances

### Access Control
- No SSH access configured by default
- Consider AWS Systems Manager Session Manager for instance access
- Use IAM roles for application permissions

## 🛠️ Development and Testing

### Local Development
```bash
# Clone the repository
git clone https://github.com/nahorfelix/terraform-challenge-day8.git
cd terraform-challenge-day8

# Test the module locally
cd live/dev/services/webserver-cluster
terraform init
terraform plan
```

### Module Testing
```bash
# Validate module syntax
terraform validate

# Format code
terraform fmt -recursive

# Security scanning (optional)
tfsec .
```

## 🚨 Known Limitations

1. **VPC Dependency**: Module uses the default VPC and subnets
2. **Region Specific**: Hardcoded availability zones for us-east-1
3. **HTTP Only**: No HTTPS/SSL support (use ALB listeners for SSL termination)
4. **Single Application**: Designed for one application per module instance

## 🤝 Contributing

This module is part of the 30-Day Terraform Challenge. Contributions welcome!

1. Fork the repository
2. Create a feature branch
3. Test your changes thoroughly
4. Submit a pull request with clear description

## 📝 Version History

- **v0.0.2** (Latest): Enhanced autoscaling with CloudWatch integration
- **v0.0.1** (Stable): Initial release with gotcha fixes and core functionality

## 📞 Support

For issues, questions, or contributions:
- GitHub Issues: [terraform-challenge-day8/issues](https://github.com/nahorfelix/terraform-challenge-day8/issues)
- Documentation: This README and inline code comments

---

*This module demonstrates professional Terraform practices including proper gotcha handling, semantic versioning, and multi-environment deployment strategies.*