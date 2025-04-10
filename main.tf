resource "aws_api_gateway_rest_api" "api" {
  name        = "MyServerlessAPI"
  description = "API Gateway for serverless architecture"
}

resource "aws_api_gateway_resource" "records" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "records"
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  # A trigger to force redeployment when the API configuration changes.
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api))
  }
  depends_on = [
    aws_api_gateway_integration.get_records_integration,
    aws_api_gateway_integration.post_processobject_integration,
    aws_api_gateway_integration.post_startglue_integration
  ]
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

module "iam_role" {
  source = "./modules/iam_role"
}

module "s3" {
  source = "./modules/s3"
  # bucket_name attribute removed as it is not expected
  environment = "prod" // or the desired value
}

// Example snippet in root main.tf:
module "lambda" {
  source                        = "./modules/lambda"
  lambda_role_arn               = module.iam_role.role_arn
  lambda_dynamodb_function_name = "process-dynamodb"
  lambda_s3_function_name       = "process-s3"
  lambda_glue_function_name     = "process-glue"
  dynamodb_table_name           = module.dynamodb.dynamodb_table_name
  s3_bucket_name                = module.s3.bucket_name # NEW: Pass the S3 bucket name from module s3
}

module "glue" {
  source         = "./modules/glue"
  iam_role_arn   = module.iam_role.role_arn
  s3_bucket_name = module.s3.bucket_name
}

# module "lambda" {
#   source                        = "./modules/lambda"
#   lambda_role_arn               = module.iam_role.role_arn # Correct attribute from iam_role module
#   lambda_dynamodb_function_name = "process-dynamodb"
#   lambda_s3_function_name       = "process-s3"
#   lambda_glue_function_name     = "process-glue"
# }

module "dynamodb" {
  source = "./modules/dynamodb"
}

# module "s3" {
#   source = "./modules/s3"
# }

# module "iam_role" {
#   source = "./modules/iam_role"
# }

# module "glue" {
#   source         = "./modules/glue"
#   iam_role_arn   = module.iam_role.role_arn # Assumes module "iam_role" outputs "lambda_role_arn"
#   s3_bucket_name = module.s3.bucket_name    # Assumes module "s3" outputs "bucket_name"
# }

resource "aws_api_gateway_method" "get_records" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.records.id
  http_method   = "GET"
  authorization = "NONE"
}

data "aws_region" "current" {}

resource "aws_api_gateway_integration" "get_records_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.records.id
  http_method             = aws_api_gateway_method.get_records.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${module.lambda.process_dynamodb_lambda_arn}/invocations"
}

resource "aws_api_gateway_method" "post_processobject" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.processobject.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_processobject_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.processobject.id
  http_method             = aws_api_gateway_method.post_processobject.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${module.lambda.process_s3_lambda_arn}/invocations"
}

resource "aws_api_gateway_method" "post_startglue" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.startglue.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_startglue_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.startglue.id
  http_method             = aws_api_gateway_method.post_startglue.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${module.lambda.process_glue_lambda_arn}/invocations"
}

resource "aws_api_gateway_stage" "api_stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "prod"
}


