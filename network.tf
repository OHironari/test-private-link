# ----------------------------------
# VPC
# ----------------------------------

resource "aws_vpc" "vpc" {
  count = 2
  cidr_block                       = count.index == 0 ? "192.168.0.0/20" : "192.169.0.0/20"
  instance_tenancy                 = "default"
  enable_dns_hostnames             = true
  enable_dns_support               = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name    = "${var.project}-${var.environment}-vpc${count.index}"
    Project = var.project
    Env     = var.environment
  }
}

# ----------------------------------
# Subnet
# ----------------------------------

resource "aws_subnet" "private_subnet" {
  count = 2
  vpc_id                  = aws_vpc.vpc[count.index].id
  availability_zone       = count.index==0 ? "ap-northeast-1a" : "ap-northeast-1c"
  cidr_block              = count.index==0 ? "192.168.12.0/24" : "192.169.12.0/24"
  map_public_ip_on_launch = false
  tags = {
    Name    = "${var.project}-${var.environment}-private${count.index}"
    Project = var.project
    Env     = var.environment
  }
}

# ----------------------------------
# Route Table
# ----------------------------------
resource "aws_route_table" "private_rt" {
  count = 2
  vpc_id = aws_vpc.vpc[count.index].id
  tags = {
    Name    = "${var.project}-${var.environment}-private_rt${count.index}"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_route_table_association" "private_rta" {
  count=2
  route_table_id = aws_route_table.private_rt[count.index].id
  subnet_id      = aws_subnet.private_subnet[count.index].id
}

# ----------------------------------
# Internet Gateway
# ----------------------------------
# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.vpc1.id
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

