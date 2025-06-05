# ----------------------------------
# key pair
# ----------------------------------

resource "aws_key_pair" "keypair" {
  key_name   = "${var.project}-${var.environment}-keypair"
  public_key = file("./myportfolio-dev-keypair.pub")

  tags = {
    Name    = "${var.project}-${var.environment}-keypair"
    Project = var.project
    Env     = var.environment
  }
}

# ----------------------------------
# ec2 instance
# ----------------------------------
resource "aws_instance" "ec2_server" {
  instance_type               = var.ec2_instance_type
  ami = var.ami_id
  subnet_id                   = aws_subnet.private_subnet_1c.id
  # iam_instance_profile        = aws_iam_instance_profile.app_ec2_profile.name
  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]
  key_name = aws_key_pair.keypair.key_name
  
  tags = {
    Name    = "${var.project}-${var.environment}-ec2"
    Project = var.project
    Env     = var.environment
    Type    = "ec2"
  }
}
