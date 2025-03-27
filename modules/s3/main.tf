resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

resource "aws_s3_bucket_policy" "my_bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.my_bucket.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_cors_configuration" "my_bucket_cors" {
  bucket = aws_s3_bucket.my_bucket.id

  cors_rule {
    allowed_methods = ["GET", "POST", "PUT"]
    allowed_origins = ["*"]
    allowed_headers = ["*"]
  }
}