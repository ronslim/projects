#test bucket with variable
resource "aws_s3_bucket" "test-bucket" {
bucket = var.bucket_id
}

resource "aws_s3_bucket_acl" "test-bucket-acl" {
  bucket = aws_s3_bucket.test-bucket.bucket
  acl = var.acl_type
}

