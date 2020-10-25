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
}
