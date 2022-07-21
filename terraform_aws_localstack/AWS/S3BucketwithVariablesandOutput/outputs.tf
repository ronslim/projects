output "bucket_name" {
  description = "AWS S3 Bucket Name"
  value       = "Bucket ID = ${aws_s3_bucket.test-bucket.bucket}"
}

output "bucket_acl" {
  description = "AWS S3 Bucket ACL Type"
  value       = "Bucket ACL Type = ${aws_s3_bucket_acl.test-bucket-acl.acl}"
}