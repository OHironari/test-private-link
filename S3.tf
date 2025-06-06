# ===========
# Define S3 Property
# ===========
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "ec2-s3-private-connection-test-ononari"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_bucket" {
  bucket                  = aws_s3_bucket.s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "s3_bucket" {
  count = 2
  bucket = aws_s3_bucket.s3_bucket.id
  policy = data.aws_iam_policy_document.bucket_policy[count.index].json
  depends_on = [ aws_s3_bucket.s3_bucket ]
}

data "aws_iam_policy_document" "bucket_policy" {
  count = 2
  statement {
    sid    = "AllowEC2RoleAccess"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.ec2_role.arn]
    }

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.s3_bucket.bucket}",
      "arn:aws:s3:::${aws_s3_bucket.s3_bucket.bucket}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:sourceVpce"
      values   = [aws_vpc_endpoint.s3[count.index].id]
    }
  }
}