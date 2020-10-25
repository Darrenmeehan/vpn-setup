# Networking

# Managing default VPC
# These usually allow all traffic, will be setitng this up to restrict to no usuage.

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

tags = {
    Name = "main"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}

output "subnet_id" {
    value = aws_subnet.main.id
}

resource "aws_security_group" "allow_wireguard" {
  name        = "allow_wiregaurd"
  description = "Allow Wireguard inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Wireguard from Anywhere"
    from_port   = 51194
    to_port     = 51194
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
    Name = "allow_wiregaurd"
  }
}