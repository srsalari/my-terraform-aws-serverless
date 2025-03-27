resource "aws_iam_role" "role_1" {
  name = "Role-1"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}

resource "aws_iam_policy" "dynamodb_policy" {
  name        = "DynamoDBPolicy"
  description = "Policy for DynamoDB access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:Scan"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy" "s3_policy" {
  name        = "S3Policy"
  description = "Policy for S3 access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy" "glue_policy" {
  name        = "GluePolicy"
  description = "Policy for Glue job execution"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "glue:StartJobRun"
        Effect = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_dynamodb_policy" {
  policy_arn = aws_iam_policy.dynamodb_policy.arn
  role       = aws_iam_role.role_1.name
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  policy_arn = aws_iam_policy.s3_policy.arn
  role       = aws_iam_role.role_1.name
}

resource "aws_iam_role_policy_attachment" "attach_glue_policy" {
  policy_arn = aws_iam_policy.glue_policy.arn
  role       = aws_iam_role.role_1.name
}