data "aws_ami" "amzn_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"] # Adjust pattern if needed
  }

  owners = ["amazon"]
}

data "aws_availability_zones" "available" {
  state = "available"
}