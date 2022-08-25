#test bucket with variable
resource "aws_s3_bucket" "report-bucket" {
bucket				= var.bucket_id

tags = {
    Key			= "Department"
    Value		= "Marketing"
  }
}

resource "aws_s3_bucket_acl" "report-bucket-acl" {
  bucket = aws_s3_bucket.report-bucket.bucket
  acl = var.acl_type
}

resource "aws_s3_bucket_versioning" "report-bucket-versioning" {
  bucket = aws_s3_bucket.report-bucket.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "report-bucket-versioning" {
  bucket = aws_s3_bucket.report-bucket.bucket

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}