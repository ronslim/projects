output "bucket_name" {
  description = "AWS S3 Bucket Name"
  value       = "Bucket ID = ${var.bucket_id}"
}

output "bucket_acl" {
  description = "AWS S3 Bucket ACL Type"
  value       = "Bucket ACL Type = ${var.acl_type}"
}