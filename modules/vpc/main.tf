# Creating VPC
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "RP-TF-VPC"
  }
}

# Subnets (both public and private)
resource "aws_subnet" "subnets" {
  for_each           = var.subnets
  vpc_id             = aws_vpc.vpc.id
  availability_zone  = each.value.az
  cidr_block         = each.value.cidr
  map_public_ip_on_launch = true
  tags = {
    Name = each.value.name
  }
}

# Creating Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "RP-TF-IGW"
  }
}

# Creating Public Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "RP-TF-Public-Route-Table"
  }
}

# Creating Private Route Table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  # No routes for the private route table in this example
  tags = {
    Name = "RP-TF-Private-Route-Table"
  }
}

# Creating Route Table Associations for Public Subnets
resource "aws_route_table_association" "public_subnet_association" {
  for_each          = { for k, v in var.subnets : k => v if v.route_table == "public" }
  subnet_id        = aws_subnet.subnets[each.key].id
  route_table_id   = aws_route_table.public_route_table.id
}

# Creating Route Table Associations for Private Subnets
resource "aws_route_table_association" "private_subnet_association" {
  for_each          = { for k, v in var.subnets : k => v if v.route_table == "private" }
  subnet_id        = aws_subnet.subnets[each.key].id
  route_table_id   = aws_route_table.private_route_table.id
}