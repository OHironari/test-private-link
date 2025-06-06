# ----------------------------------
# security group
# ----------------------------------
# App EC2 Security Group
resource "aws_security_group" "ec2_sg" {
  count = 2
  name        = "${var.project}-${var.environment}-ec2_sg-${count.index + 1}"
  description = "App EC2 security group"
  vpc_id      = aws_vpc.vpc[count.index].id
  tags = {
    Name    = "${var.project}-${var.environment}-ec2-sg"
    Project = var.project
    Env     = var.environment
  }
}


resource "aws_security_group_rule" "ec2_out_tcp" {
  count = 2
  security_group_id = aws_security_group.ec2_sg[count.index].id
  type                     = "egress"
  protocol                 = "-1"
  from_port                = 0
  to_port                  = 0
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ec2_in_http" {
  count = 2
  security_group_id        = aws_security_group.ec2_sg[count.index].id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = aws_security_group.ec2_sg[count.index].id
}

resource "aws_security_group_rule" "ec2_in_ssh" {
  count = 2
  security_group_id        = aws_security_group.ec2_sg[count.index].id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  source_security_group_id = aws_security_group.ec2_endpoint_sg[count.index].id
}

# EC2 Instance endpoint Security Group #1
resource "aws_security_group" "ec2_endpoint_sg" {
  count = 2
  name        = "${var.project}-${var.environment}-ec2-endpoint_sg${count.index + 1}"
  description = "App EC2 Endpoint security group"
  vpc_id      = aws_vpc.vpc[count.index].id
  tags = {
    Name    = "${var.project}-${var.environment}-ec2-endpoint-sg1z"
    Project = var.project
    Env     = var.environment
  }
}



resource "aws_security_group_rule" "ec2_endpoint_out_ssh" {
  count = 2
  security_group_id        = aws_security_group.ec2_endpoint_sg[count.index].id
  type                     = "egress"
  protocol                 = "-1"
  from_port                = 0
  to_port                  = 0
  cidr_blocks = ["0.0.0.0/0"]
}