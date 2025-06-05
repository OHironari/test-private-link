# ----------------------------------
# VPC
# ----------------------------------

resource "aws_vpc" "vpc" {
  cidr_block                       = "192.168.0.0/20"
  instance_tenancy                 = "default"
  enable_dns_hostnames             = true
  enable_dns_support               = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name    = "${var.project}-${var.environment}-vpc"
    Project = var.project
    Env     = var.environment
  }
}

# ----------------------------------
# Subnet
# ----------------------------------

resource "aws_subnet" "private_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "192.168.12.0/24"
  map_public_ip_on_launch = false
  tags = {
    Name    = "${var.project}-${var.environment}-private(ap-northeast-1c)"
    Project = var.project
    Env     = var.environment
  }
}

# ----------------------------------
# Route Table
# ----------------------------------
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-${var.environment}-private_rt"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_route_table_association" "private_rta_1c" {
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnet_1c.id
}

# ----------------------------------
# Internet Gateway
# ----------------------------------
# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.vpc.id
#   tags = {
#     Name    = "${var.project}-${var.environment}-igw"
#     Project = var.project
#     Env     = var.environment
#   }
# }

# resource "aws_route" "igw_route" {
#   route_table_id         = aws_route_table.public_rt.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.igw.id
# }

