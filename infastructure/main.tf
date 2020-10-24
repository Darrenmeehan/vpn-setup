# Networking

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_eip" "public_ip" {
  instance = aws_instance.vpn.id
  vpc      = true
}

output "public_ip" {
  value = aws_eip.public_ip.public_ip
}

data "aws_ami" "amazonlinux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "vpn" {
  ami           = data.aws_ami.amazonlinux.id
  instance_type = "t3.micro"

  tags = {
    Name = "HelloWorld"
  }
}

output "ec2_instance_id" {
  value = aws_instance.vpn.id
}