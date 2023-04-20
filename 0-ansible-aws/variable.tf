variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  default     = "10.10.0.0/16"
}

variable "public_subnet_cidr_block" {
  description = "The CIDR block for the public subnet"
  default     = "10.10.1.0/24"
}

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  default     = "us-east-1"
}

variable "instance_count" {
  description = "The number of instances to create"
  default     = 3
}

variable "ami_id" {
  description = "The Amazon Machine Image (AMI) ID to use for instances"
  default     = "ami-00c39f71452c08778"
}

variable "instance_type" {
  description = "The type of instances to create"
  default     = "t2.micro"
}

variable "key_name" {
  description = "The name of the keypair to use for SSH access"
  default     = "kay-va"  # Use an existing keypair for SSH access
}

variable "ansible_user" {
  description = "The Ansible user for the instances"
  default     = "ec2-user"
}

variable "ansible_ssh_private_key_file" {
  description = "The path to the private key file for Ansible SSH access"
  default     = "/Users/vagrant/.ssh/kay-va.pem"
}

variable "ansible_python_interpreter" {
  description = "The path to the Python interpreter on the instances"
  default     = "/usr/bin/python3"
}

