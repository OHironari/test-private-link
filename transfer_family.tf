# ----------------------------------
# transfer family
# ----------------------------------
resource "aws_transfer_server" "access_s3" {
  endpoint_type = "VPC"

  endpoint_details {
    subnet_ids = [aws_subnet.private_subnet[var.select_network].id]
    vpc_id     = aws_vpc.vpc[var.select_network].id
    security_group_ids=[aws_security_group.transfer_family_sg.id]
  }
  domain="S3"
  protocols   = ["SFTP"]
  identity_provider_type = "SERVICE_MANAGED"
}

resource "aws_transfer_user" "transfer_user" {
  server_id = aws_transfer_server.access_s3.id
  user_name = "transfer_user"
  role      = aws_iam_role.transfer_family_user_role.arn
  home_directory = "/home/transfer_user"
#   home_directory_mappings = [
#     {
#       entry  = "/home/transfer_user"
#       target = "${aws_s3_bucket.s3_bucket.arn}/home/transfer_user"
#     }
#     ]
}

resource "tls_private_key" "sshkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_transfer_ssh_key" "sshkey" {
  server_id = aws_transfer_server.access_s3.id
  user_name = aws_transfer_user.transfer_user.user_name
  body      = trimspace(tls_private_key.sshkey.public_key_openssh)
}

output "sftp_private_key_pem" {
  value     = tls_private_key.sshkey.private_key_pem
  sensitive = true
}
