variable "bucket_id" {
description	= "Set bucket name for AWS S3"
type		= string
}

variable "acl_type" {
description	= "Set ACL type for AWS S3"
type		= string
default		= "public-read-write"
}