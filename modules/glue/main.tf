resource "aws_glue_job" "hello_world" {
  name     = "HelloWorld"
  role_arn = var.iam_role_arn
  command {
    name            = "glueetl"
    script_location = "s3://${var.s3_bucket_name}/scripts/hello_world.py"
    python_version  = "3"
  }
  default_arguments = {
    "--TempDir"      = "s3://${var.s3_bucket_name}/temp/"
    "--job-language" = "python"
  }
  max_retries = 1
  timeout     = 10
}

resource "aws_glue_catalog_database" "default" {
  name = "default"
}

resource "aws_glue_catalog_table" "example_table" {
  database_name = aws_glue_catalog_database.default.name
  name          = "example_table"

  storage_descriptor {
    location      = "s3://${var.s3_bucket_name}/data/"
    input_format  = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"

    columns {
      name = "id"
      type = "int"
    }
    columns {
      name = "data"
      type = "string"
    }
  }
}
