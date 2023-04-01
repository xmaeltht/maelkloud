# Create a VPC with a single public subnet and a single private subnet
resource "aws_vpc" "ansible" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "ansible_VPC"
  }
}

# Create an Internet Gateway and attach it to the VPC
resource "aws_internet_gateway" "ansible" {
  vpc_id = aws_vpc.ansible.id
}

# Create a public subnet in the VPC
resource "aws_subnet" "ansible_subnet"{
    cidr_block = "10.10.1.0/24"
    vpc_id     = aws_vpc.ansible.id
    map_public_ip_on_launch = true

    tags = {
      Name = "Ansible_Public_Subnet"
    }
  }

# Create a route table and associate it with the public subnet
resource "aws_route_table" "ansible" {
  vpc_id = aws_vpc.ansible.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ansible.id
  }
}

resource "aws_route_table_association" "ansible" {
  subnet_id      = aws_subnet.ansible_subnet.id
  route_table_id = aws_route_table.ansible.id
}

# Create a security group that allows incoming SSH traffic on port 22
resource "aws_security_group" "ssh" {
  name_prefix = "ssh"
  vpc_id = aws_vpc.ansible.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SSH"
  }
}