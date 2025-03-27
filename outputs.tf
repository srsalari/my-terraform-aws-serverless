output "api_gateway_url" {
  value = module.api_gateway.api_gateway_url
}

output "process_dynamodb_lambda_arn" {
  value = module.lambda.process_dynamodb_lambda_arn
}

output "process_s3_lambda_arn" {
  value = module.lambda.process_s3_lambda_arn
}

output "process_glue_lambda_arn" {
  value = module.lambda.process_glue_lambda_arn
}

output "s3_bucket_url" {
  value = module.s3.s3_bucket_url
}