variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "movie-agency-s3-bucket-03-2025"
}

variable "environment" {
  description = "The deployment environment (e.g. dev, prod)"
  type        = string
  default     = "dev"
}
