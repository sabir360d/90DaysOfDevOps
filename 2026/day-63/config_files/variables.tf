# String variable with default
variable "region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

# String variable with default
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# String variable with default
variable "subnet_cidr" {
  description = "CIDR block for subnet"
  type        = string
  default     = "10.0.1.0/24"
}

# String variable - NO default (user must provide)
variable "project_name" {
  description = "Name of the project"
  type        = string

  validation {
    condition     = length(var.project_name) > 0
    error_message = "Project name must not be empty."
  }
}

# String variable with default
variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

# List variable
variable "allowed_ports" {
  description = "Allowed inbound ports"
  type        = list(number)
  default     = [22, 80, 443]
}

# Map variable
variable "extra_tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
}

# String variable with default (explicit type)
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"    # Changed from t2.micro to t3.micro

  validation {
    condition     = contains(["t3.micro", "t3.small", "t4g.micro", "t4g.small"], var.instance_type)
    error_message = "Instance type must be Free Tier eligible in 2026: t3.micro, t3.small, t4g.micro, or t4g.small"
  }
}

