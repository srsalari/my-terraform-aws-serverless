variable "iam_role_arn" {
  description = "The IAM role ARN to be used for the Glue job"
  type        = string
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket used for Glue scripts, temp files, and data"
  type        = string
}
