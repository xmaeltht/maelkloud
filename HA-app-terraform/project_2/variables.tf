variable "region" {
  description = "AWS region for deployment"
  default     = "us-west-1"
}

variable "vpc_cidr" {
  description = "CIDR block for your VPC"
  default     = "30.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets (one per AZ)"
  type        = list(string)
  default     = ["30.0.1.0/24", "30.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets (one per AZ)"
  type        = list(string)
  default     = ["30.0.3.0/24", "30.0.4.0/24"]
}

variable "keypair_name" {
  description = "The name of the keypair to use or create"
  default     = "mkloud-guru"
}

variable "availability_zones" {
  description = "List of AZs to use"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"] 
}

variable "web_sg" {
  description = "The name of the sg"
  default = "web_sg"
}

variable "alb_sg" {
  description = "The name of the sg"
  default = "alb_sg"
}