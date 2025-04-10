variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "ca-central-1"
}
variable "api_gateway_name" {
  description = "The name of the API Gateway"
  type        = string
  default     = "MyApiGateway"
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table"
  type        = string
  default     = "MyDynamoDBTable"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  default     = "movie-agency-s3-bucket-03-2025"
}

variable "glue_job_name" {
  description = "The name of the AWS Glue job"
  type        = string
  default     = "HelloWorld"
}

variable "lambda_role_name" {
  description = "The name of the IAM role for Lambda functions"
  type        = string
  default     = "Role-1"
}



