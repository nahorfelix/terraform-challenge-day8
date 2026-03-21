# 30-Day Terraform Challenge - Day 8: Building Reusable Infrastructure Modules

This repository demonstrates professional Terraform module development as part of the 30-Day Terraform Challenge. The project showcases how to build reusable infrastructure components that can be deployed across multiple environments with different configurations.

## 🏗️ Architecture Overview

The infrastructure implements a scalable web application cluster using AWS services:

- **Application Load Balancer (ALB)** - Distributes incoming traffic across healthy instances
- **Auto Scaling Group** - Automatically manages EC2 instance capacity based on demand
- **Launch Templates** - Defines the configuration template for EC2 instances
- **Target Groups** - Routes traffic to healthy instances with configurable health checks
- **Security Groups** - Implements network-level security with least-privilege access

## 📁 Project Structure

```
terraform-challenge/
├── modules/                          # Reusable Terraform modules
│   └── services/
│       ├── node-app-cluster/         # Production-ready web cluster module
│       │   ├── main.tf              # Resource definitions
│       │   ├── variables.tf         # Input parameters
│       │   └── outputs.tf           # Exposed values
│       └── webserver-cluster/        # Alternative implementation
│           ├── main.tf
│           ├── variables.tf
│           ├── outputs.tf
│           └── README.md
├── live/                            # Environment-specific configurations
│   ├── dev/                         # Development environment
│   │   └── services/
│   │       └── webserver-cluster/
│   │           └── main.tf
│   ├── production/                  # Production environment
│   │   └── services/
│   │       └── webserver-cluster/
│   │           └── main.tf
│   └── staging/                     # Staging environment (deployed)
│       └── services/
│           └── node-app-cluster/
│               └── main.tf
└── README.md                        # This file
```

## 🚀 Quick Start

### Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.0 installed
- Access to an AWS account with EC2 and ELB permissions

### Deployment Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd terraform-challenge
   ```

2. **Navigate to your desired environment**
   ```bash
   cd live/staging/services/node-app-cluster
   ```

3. **Initialize Terraform**
   ```bash
   terraform init
   ```

4. **Review the deployment plan**
   ```bash
   terraform plan
   ```

5. **Deploy the infrastructure**
   ```bash
   terraform apply
   ```

6. **Access your application**
   ```bash
   terraform output alb_dns_name
   ```

## 📋 Module Documentation

### Node App Cluster Module

The `node-app-cluster` module creates a complete web application infrastructure with the following components:

#### Input Variables

| Variable | Type | Required | Default | Description |
|----------|------|----------|---------|-------------|
| `cluster_name` | string | ✅ | - | Unique identifier for all cluster resources |
| `min_size` | number | ✅ | - | Minimum number of EC2 instances in the Auto Scaling Group |
| `max_size` | number | ✅ | - | Maximum number of EC2 instances in the Auto Scaling Group |
| `instance_type` | string | ❌ | `t3.micro` | EC2 instance type for the cluster |
| `app_port` | number | ❌ | `8080` | Port for application HTTP requests |
| `server_port` | number | ❌ | `8080` | Port for internal health checks |

#### Outputs

| Output | Description |
|--------|-------------|
| `alb_dns_name` | DNS name of the Application Load Balancer |
| `asg_name` | Name of the Auto Scaling Group |

#### Usage Example

```hcl
module "web_cluster" {
  source = "../../../../modules/services/node-app-cluster"

  cluster_name  = "my-web-app"
  instance_type = "t3.micro"
  min_size      = 2
  max_size      = 10
  server_port   = 8080
}

output "application_url" {
  value = "http://${module.web_cluster.alb_dns_name}"
}
```

## 🌍 Multi-Environment Strategy

This project demonstrates infrastructure deployment across multiple environments using the same reusable modules:

### Development Environment
- **Purpose**: Feature development and testing
- **Instance Type**: `t3.micro` (cost-optimized)
- **Scaling**: 1-2 instances
- **Configuration**: `live/dev/services/webserver-cluster/`

### Staging Environment  
- **Purpose**: Pre-production testing and validation
- **Instance Type**: `t3.micro` 
- **Scaling**: 0-0 instances (demo configuration due to account limits)
- **Configuration**: `live/staging/services/node-app-cluster/`
- **Status**: ✅ Successfully Deployed

### Production Environment
- **Purpose**: Live application serving real users
- **Instance Type**: `t3.small` (performance-optimized)
- **Scaling**: 1-3 instances
- **Configuration**: `live/production/services/webserver-cluster/`

## 🔧 Key Features

### Dynamic AMI Selection
The modules automatically select the latest Amazon Linux 2 AMI, ensuring deployments use current, patched images without manual updates.

### Modern Terraform Patterns
- **Launch Templates** instead of deprecated Launch Configurations
- **Data sources** for dynamic resource discovery
- **Lifecycle management** for zero-downtime updates
- **Proper resource dependencies** ensuring correct creation order

### Security Best Practices
- **Least-privilege security groups** - Instances only accept traffic from the load balancer
- **Network segmentation** - Clear separation between public (ALB) and private (instances) access
- **Health checks** - Automatic detection and replacement of unhealthy instances

## 📊 Infrastructure Monitoring

The deployed infrastructure includes comprehensive health monitoring:

- **ELB Health Checks**: Automatic instance health verification
- **Auto Scaling**: Automatic capacity adjustment based on demand
- **CloudWatch Integration**: Built-in metrics and monitoring
- **Multi-AZ Deployment**: High availability across multiple availability zones

## 🛠️ Customization

### Scaling Configuration
Adjust the `min_size` and `max_size` variables based on your traffic patterns:

```hcl
# Light traffic
min_size = 1
max_size = 3

# Heavy traffic
min_size = 3
max_size = 20
```

### Instance Types
Choose appropriate instance types for your workload:

```hcl
# Development/Testing
instance_type = "t3.micro"

# Production
instance_type = "t3.medium"

# High-performance
instance_type = "c5.large"
```

## 🔒 Security Considerations

- **State Files**: Terraform state files contain sensitive information and should be stored in secure remote backends (S3 with encryption)
- **Access Keys**: Never commit AWS credentials to version control
- **Network Security**: Security groups implement defense-in-depth networking
- **Resource Tagging**: All resources are properly tagged for cost allocation and management

## 🚨 Important Notes

- The staging environment is configured with 0 instances due to AWS Free Tier limitations
- All infrastructure components (ALB, Target Groups, Security Groups) are successfully deployed
- The module architecture is fully functional and ready for production use
- Instance limits can be adjusted based on your AWS account quotas

## 📈 Next Steps

1. **Remote State**: Configure S3 backend for state management
2. **CI/CD Integration**: Add automated testing and deployment pipelines  
3. **Monitoring**: Implement CloudWatch alarms and notifications
4. **SSL/TLS**: Add HTTPS support with ACM certificates
5. **Database Integration**: Add RDS or other data storage services

## 🤝 Contributing

This project is part of the 30-Day Terraform Challenge. Feel free to fork and experiment with different configurations or extend the modules with additional features.

## 📝 License

This project is open source and available under the MIT License.

---

**Day 8 Challenge Status**: ✅ **COMPLETED**

*Successfully demonstrated reusable Terraform modules with multi-environment deployment capabilities.*