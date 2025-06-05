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

# resource "aws_s3_bucket_policy" "s3_bucket" {
#   bucket = aws_s3_bucket.s3_bucket.id
#   policy = data.aws_iam_policy_document.s3_bucket.json
#   depends_on = [ aws_s3_bucket.s3_bucket ]
# }

# data "aws_iam_policy_document" "s3_bucket" {
#   statement {
#     effect    = "Allow"
#     actions   = ["s3:GetObject"]
#     resources = ["${aws_s3_bucket.s3_bucket.arn}/*"]
#     principals {
#       type        = "AWS"
#       identifiers = [var.iam_arn]
#     }
#   }
# }