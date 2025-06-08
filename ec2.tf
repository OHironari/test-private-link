# ----------------------------------
# key pair
# ----------------------------------

# resource "aws_key_pair" "keypair" {
#   key_name   = "${var.project}-${var.environment}-keypair"
#   public_key = file("./myportfolio-dev-keypair.pub")

#   tags = {
#     Name    = "${var.project}-${var.environment}-keypair"
#     Project = var.project
#     Env     = var.environment
#   }
# }

# ----------------------------------
# ec2 instance
# ----------------------------------
resource "aws_instance" "ec2_server" {
  count = 2
  instance_type               = var.ec2_instance_type
  ami = var.ami_id
  subnet_id                   = aws_subnet.private_subnet[count.index].id
  iam_instance_profile        = aws_iam_instance_profile.access_s3.name
  vpc_security_group_ids = [
    aws_security_group.ec2_sg[count.index].id
  ]
  #key_name = aws_key_pair.keypair.key_name
  
  tags = {
    Name    = "${var.project}-${var.environment}-ec2-${count.index}"
    Project = var.project
    Env     = var.environment
    Type    = "ec2"
  }
}


