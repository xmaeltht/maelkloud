# Define the AWS provider
provider "aws" {
  region = "us-east-1"
}

# Create 3 instances
resource "aws_instance" "ansible" {
  count         = 3
  ami           = "ami-00c39f71452c08778"
  instance_type = "t2.micro"
  key_name      = "mae" # Use an existing keypair for SSH access
  vpc_security_group_ids = [aws_security_group.ssh.id]
  subnet_id     = aws_subnet.ansible_subnet.id  

  # Add tags to each instance
  tags = {
    Name = "Ansible_host_${count.index + 1}"
  }
}

# Output the public IP addresses of the instances to a local file
locals {
  public_ips = {
    for instance in aws_instance.ansible : instance.tags.Name => instance.public_ip
  }
}

# Use the file() function to write the output to a local file named "public_ips.txt"
# This file will be created in the same directory as the Terraform code
# The format of the file will be one instance name and public IP address per line
# The file will be overwritten each time Terraform is run
# Note that the file() function is available in Terraform 0.12 and later
resource "local_file" "public_ips" {
  content = <<-EOF
    [my-ansible-instances]

    ${join("\n", [for name, ip in local.public_ips : "${ip} ansible_user=ec2-user ansible_ssh_private_key_file=/Users/mae/.ssh/mae.pem ansible_python_interpreter=/usr/bin/python3"])}
  EOF
  filename = "ansible_inventory.ini"
}
