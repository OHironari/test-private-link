# ----------------------------------
# ec2 instance connection endpoint #1
# ----------------------------------

resource "aws_ec2_instance_connect_endpoint" "ec2" {
  count = 2
  subnet_id = aws_subnet.private_subnet[count.index].id
  security_group_ids = [ aws_security_group.ec2_endpoint_sg[count.index].id]
}

# ----------------------------------
# S3 private endpoint
# ----------------------------------

resource "aws_vpc_endpoint" "s3" {
  count = 2
  vpc_id       = aws_vpc.vpc[count.index].id
  service_name = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [aws_route_table.private_rt[count.index].id]
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = "*",
      Action = "s3:*",
      Resource = "*"
    }]
  })
}



