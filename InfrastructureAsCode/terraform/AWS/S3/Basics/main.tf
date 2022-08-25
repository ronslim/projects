#test bucket with variable
resource "aws_s3_bucket" "report-bucket" {
bucket				= "testbucketbasics082022"

tags = {
    Key			= "Department"
    Value		= "Marketing"
  }
}

resource "aws_s3_bucket_acl" "report-bucket-acl" {
  bucket = "testbucketbasics082022"
  acl = "public-read-write"
}

resource "aws_s3_bucket_versioning" "report-bucket-versioning" {
  bucket = "testbucketbasics082022"
  versioning_configuration {
    status = "Enabled"
  }
}