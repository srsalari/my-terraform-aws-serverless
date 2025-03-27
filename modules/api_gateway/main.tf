resource "aws_api_gateway_rest_api" "api" {
  name        = "MyServerlessAPI"
  description = "API for serverless architecture"
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

resource "aws_lambda_permission" "allow_api_gateway_records" {
  statement_id  = "AllowAPIGatewayRecords"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.process_dynamodb_function_name
  principal     = "apigateway.amazonaws.com"

  # The source ARN is the ARN of the API Gateway method
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/resources/${aws_api_gateway_resource.records.id}/methods/POST"
}

resource "aws_api_gateway_method" "post_records" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.records.id
  http_method   = "POST"
  authorization = "NONE"

  integration {
    type             = "AWS_PROXY"
    integration_http_method = "POST"
    uri              = module.lambda.process_dynamodb_invoke_arn
  }
}

resource "aws_lambda_permission" "allow_api_gateway_processobject" {
  statement_id  = "AllowAPIGatewayProcessObject"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.process_s3_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/resources/${aws_api_gateway_resource.processobject.id}/methods/POST"
}

resource "aws_api_gateway_method" "post_processobject" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.processobject.id
  http_method   = "POST"
  authorization = "NONE"

  integration {
    type             = "AWS_PROXY"
    integration_http_method = "POST"
    uri              = module.lambda.process_s3_invoke_arn
  }
}

resource "aws_lambda_permission" "allow_api_gateway_startglue" {
  statement_id  = "AllowAPIGatewayStartGlue"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.process_glue_function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/resources/${aws_api_gateway_resource.startglue.id}/methods/POST"
}

resource "aws_api_gateway_method" "post_startglue" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.startglue.id
  http_method   = "POST"
  authorization = "NONE"

  integration {
    type             = "AWS_PROXY"
    integration_http_method = "POST"
    uri              = module.lambda.process_glue_invoke_arn
  }
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_method.post_records,
    aws_api_gateway_method.post_processobject,
    aws_api_gateway_method.post_startglue,
  ]

  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "v1"
}