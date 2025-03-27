resource "aws_api_gateway_rest_api" "api" {
  name        = "MyServerlessAPI"
  description = "API Gateway for serverless architecture"
}

resource "aws_api_gateway_resource" "records" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "records"
}

resource "aws_api_gateway_resource" "processobject" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "processobject"
}

resource "aws_api_gateway_resource" "startglue" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "startglue"
}

module "lambda" {
  source = "./modules/lambda"
}

module "dynamodb" {
  source = "./modules/dynamodb"
}

module "s3" {
  source = "./modules/s3"
}

module "iam_role" {
  source = "./modules/iam_role"
}

module "glue" {
  source = "./modules/glue"
}

resource "aws_api_gateway_method" "get_records" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.records.id
  http_method   = "GET"
  authorization = "NONE"

  integration {
    type             = "AWS_PROXY"
    integration_http_method = "POST"
    uri              = module.lambda.process_dynamodb_lambda.invoke_arn
  }
}

resource "aws_api_gateway_method" "post_records" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.records.id
  http_method   = "POST"
  authorization = "NONE"

  integration {
    type             = "AWS_PROXY"
    integration_http_method = "POST"
    uri              = module.lambda.process_dynamodb_lambda.invoke_arn
  }
}

resource "aws_api_gateway_method" "post_processobject" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.processobject.id
  http_method   = "POST"
  authorization = "NONE"

  integration {
    type             = "AWS_PROXY"
    integration_http_method = "POST"
    uri              = module.lambda.process_s3_lambda.invoke_arn
  }
}

resource "aws_api_gateway_method" "post_startglue" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.startglue.id
  http_method   = "POST"
  authorization = "NONE"

  integration {
    type             = "AWS_PROXY"
    integration_http_method = "POST"
    uri              = module.lambda.process_glue_lambda.invoke_arn
  }
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "prod"
}

output "api_gateway_url" {
  value = "${aws_api_gateway_deployment.api_deployment.invoke_url}/prod"
}

output "process_dynamodb_lambda_arn" {
  value = module.lambda.process_dynamodb_lambda.invoke_arn
}

output "process_s3_lambda_arn" {
  value = module.lambda.process_s3_lambda.invoke_arn
}

output "process_glue_lambda_arn" {
  value = module.lambda.process_glue_lambda.invoke_arn
}

output "s3_bucket_url" {
  value = module.s3.bucket_website_url
}