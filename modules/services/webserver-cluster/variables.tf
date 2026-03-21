# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be passed by the calling module
# ---------------------------------------------------------------------------------------------------------------------

variable "cluster_name" {
  description = "The name to use for all cluster resources"
  type        = string
}

variable "min_size" {
  description = "Minimum number of EC2 instances in the ASG"
  type        = number
}

variable "max_size" {
  description = "Maximum number of EC2 instances in the ASG"
  type        = number
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These have defaults, but can be overridden if needed
# ---------------------------------------------------------------------------------------------------------------------

variable "instance_type" {
  description = "EC2 instance type for the cluster"
  type        = string
  default     = "t3.micro"
}

variable "server_port" {
  description = "Port the server uses for HTTP"
  type        = number
  default     = 8080
}