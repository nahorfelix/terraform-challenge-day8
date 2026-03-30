# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be passed by the calling module (e.g., in live/staging/main.tf)
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_name" {
  description = "The name to use for all cluster resources (e.g. node-app-staging)"
  type        = string
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type        = number
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type        = number
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These have defaults, but can be overridden if needed
# ---------------------------------------------------------------------------------------------------------------------

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t3.micro)"
  type        = string
  default     = "t3.micro"
}

variable "app_port" {
  description = "The port the application will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "server_port" {
  description = "The port the server uses for internal health checks (if different from app_port)"
  type        = number
  default     = 8080
}