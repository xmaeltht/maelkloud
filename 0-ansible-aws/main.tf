# Define the AWS provider
provider "aws" {
  region = var.aws_region
}

# Create 3 instances
resource "aws_instance" "ansible" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
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
  sorted_ips = sort(values(local.public_ips))  # sort the IPs in ascending order
  group_a = slice(local.sorted_ips, 0, 1)      # take the first IP and put it in group A
  group_b = slice(local.sorted_ips, 1, 3)     # take the last 2 IPs and put them in group B
}

# Use the file() function to write the output to a local file named "ansible_inventory.ini"
# This file will be created in the same directory as the Terraform code
# The format of the file will be one instance name and public IP address per line
# The file will be overwritten each time Terraform is run
# Note that the file() function is available in Terraform 0.12 and later
resource "local_file" "public_ips" {
  content = <<-EOF
    [group_a]
    ${join("\n", [for ip in local.group_a : "${ip} ansible_user=${var.ansible_user} ansible_ssh_private_key_file=${var.ansible_ssh_private_key_file} ansible_python_interpreter=${var.ansible_python_interpreter}"])}

    [group_b]
    ${join("\n", [for ip in local.group_b : "${ip} ansible_user=${var.ansible_user} ansible_ssh_private_key_file=${var.ansible_ssh_private_key_file} ansible_python_interpreter=${var.ansible_python_interpreter}"])}
  EOF
  filename = "ansible_inventory.ini"
}

# This file will be used to avoid ancsible to check host_key
resource "local_file" "ansible_cfg" {
  content  = "[defaults]\nhost_key_checking = False\n"
  filename = "ansible.cfg"
}
