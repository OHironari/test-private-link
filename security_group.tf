# ----------------------------------
# security group
# ----------------------------------
# App EC2 Security Group
resource "aws_security_group" "ec2_sg" {
  name        = "${var.project}-${var.environment}-ec2_sg"
  description = "App EC2 security group"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-${var.environment}-ec2-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "ec2_out_tcp" {
  security_group_id        = aws_security_group.ec2_sg.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 0
  to_port                  = 0
  source_security_group_id = aws_security_group.ec2_sg.id
}

resource "aws_security_group_rule" "ec2_in_http" {
  security_group_id        = aws_security_group.ec2_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = aws_security_group.ec2_sg.id
}

resource "aws_security_group_rule" "ec2_in_ssh" {
  security_group_id        = aws_security_group.ec2_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  source_security_group_id = aws_security_group.ec2_endpoint_sg.id
}

# App EC2 Security Group
resource "aws_security_group" "ec2_endpoint_sg" {
  name        = "${var.project}-${var.environment}-ec2-endpoint_sg"
  description = "App EC2 Endpoint security group"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name    = "${var.project}-${var.environment}-ec2-endpoint-sg"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_security_group_rule" "ec2_endpoint_out_ssh" {
  security_group_id        = aws_security_group.ec2_endpoint_sg.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  source_security_group_id = aws_security_group.ec2_sg.id
}