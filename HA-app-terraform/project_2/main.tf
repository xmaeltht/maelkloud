# Provider setup
provider "aws" {
  region = var.region
}

# VPC and Subnets
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "ha-app-vpc"
  }
}

# Shuffle the AZs - Important!
resource "random_shuffle" "azs" {
  input        = data.aws_availability_zones.available.names
  result_count = length(var.availability_zones)
}

# Two public subnets (one in each AZ)
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = random_shuffle.azs.result[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "ha-app-public-subnet-${count.index + 1}"
  }
}

# Two private subnets (one in each AZ)
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = random_shuffle.azs.result[count.index]

  tags = {
    Name = "ha-app-private-subnet-${count.index + 1}"
  }
}

# Internet Gateway (for public subnets)
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "ha-app-igw"
  }
}

# Route Table and Association for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "ha-app-public-rt"
  }
}

resource "aws_route_table_association" "public_subnets" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public.id
}

# NAT Gateway for Private Subnets 
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = {
    Name = "ha-app-natgw"
  }
}

resource "aws_eip" "nat" {
  depends_on = [aws_internet_gateway.main]
}

# Route Table and Association for Private Subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "ha-app-private-rt"
  }
}

resource "aws_route_table_association" "private_subnets" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private.id
}


# Security Groups
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.main.id
  name = var.alb_sg

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ha-app-alb-sg"
  }
}

resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main.id
  name = var.web_sg

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ha-app-web-sg"
  }
}


# EC2 Instances (in private subnets)
resource "aws_instance" "web_servers" {
  count           = 2
  ami             = data.aws_ami.amzn_linux.id
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.private_subnets[count.index].id
  security_groups = [aws_security_group.web_sg.id]
  key_name        = var.keypair_name
  user_data       = file("./server${count.index + 1}_userdata.sh")

  tags = {
    Name = "ha-app-web-server-${count.index + 1}"
  }
}

# Target Group
resource "aws_lb_target_group" "main" {
  name     = "ha-app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# Target Group Attachments
resource "aws_lb_target_group_attachment" "web_servers" {
  count            = length(aws_instance.web_servers)
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.web_servers[count.index].id
  port             = 80
}

# Application Load Balancer
resource "aws_lb" "main" {
  name               = "ha-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = aws_subnet.public_subnets.*.id
}

# Listener 
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
