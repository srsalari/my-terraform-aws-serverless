variable "lambda_role_arn" {
  description = "The ARN of the Lambda execution role"
  type        = string
}

variable "lambda_dynamodb_function_name" {
  description = "The name of the Lambda function for processing DynamoDB"
  type        = string
}

variable "lambda_s3_function_name" {
  description = "The name of the Lambda function for processing S3"
  type        = string
}

variable "lambda_glue_function_name" {
  description = "The name of the Lambda function for processing Glue"
  type        = string
}

variable "s3_bucket_name" {
  description = "The S3 bucket name for the S3 processing lambda function"
  type        = string
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table for Lambda use"
  type        = string
}
