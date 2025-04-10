resource "aws_lambda_function" "process_dynamodb" {
  function_name    = var.lambda_dynamodb_function_name
  handler          = "process_dynamodb.lambda_handler"
  runtime          = "python3.8"
  role             = var.lambda_role_arn
  source_code_hash = filebase64sha256("lambda_functions/process_dynamodb.py")

  environment {
    variables = {
      DYNAMODB_TABLE = var.dynamodb_table_name
    }
  }

  filename = "lambda_functions/process_dynamodb.zip"
}

resource "aws_lambda_function" "process_s3" {
  function_name    = var.lambda_s3_function_name
  handler          = "process_s3.lambda_handler"
  runtime          = "python3.8"
  role             = var.lambda_role_arn
  source_code_hash = filebase64sha256("lambda_functions/process_s3.py")

  environment {
    variables = {
      S3_BUCKET = var.s3_bucket_name
    }
  }

  filename = "lambda_functions/process_s3.zip"
}

resource "aws_lambda_function" "process_glue" {
  function_name    = var.lambda_glue_function_name
  handler          = "process_glue.lambda_handler"
  runtime          = "python3.8"
  role             = var.lambda_role_arn
  source_code_hash = filebase64sha256("lambda_functions/process_glue.py")

  filename = "lambda_functions/process_glue.zip"
}

output "process_dynamodb_lambda_arn" {
  value = aws_lambda_function.process_dynamodb.arn
}

output "process_s3_lambda_arn" {
  value = aws_lambda_function.process_s3.arn
}

output "process_glue_lambda_arn" {
  value = aws_lambda_function.process_glue.arn
}
