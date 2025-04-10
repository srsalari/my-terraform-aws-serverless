output "bucket_name" {
  value = var.s3_bucket_name
}

output "s3_bucket_url" {
  value = aws_s3_bucket_website_configuration.my_bucket_website.website_endpoint
}
