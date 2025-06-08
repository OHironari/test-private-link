# ----------------------------------
# IAM Policy 
# ----------------------------------

#To Connect EC2 to S3

resource "aws_iam_instance_profile" "access_s3" {
    name = "ec2-to-s3"
    role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2-to-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "s3_read_policy" {
  name        = "S3ReadAccess"
  description = "Allow EC2 to read from S3"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["s3:GetObject", "s3:ListBucket","s3:PutObject"],
      Resource = [aws_s3_bucket.s3_bucket.arn,"${aws_s3_bucket.s3_bucket.arn}/*"]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_read_policy.arn
}



# For attach transfer family
resource "aws_iam_role" "transfer_family_user_role" {
  name               = "transfer_family_user_role"
  assume_role_policy = data.aws_iam_policy_document.transfer_assume.json
}

resource "aws_iam_role_policy_attachment" "transfer_access_s3_policy" {
  role       = aws_iam_role.transfer_family_user_role.name
  policy_arn = aws_iam_policy.s3_read_policy.arn
}

data "aws_iam_policy_document" "transfer_assume" {
  statement {
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "transfer.amazonaws.com",
      ]
    }

    actions = [
      "sts:AssumeRole",
      "sts:SetContext",
    ]
  }
}

