# aws_lambda_function.process-jpeg-images
resource "aws_lambda_function" "process-jpeg-images" {
  description   = "An Amazon S3 trigger that retrieves metadata for the object that has been updated."
  function_name = var.lambda_function_name
  handler       = "lambda_function.lambda_handler"
  lifecycle {
    ignore_changes = [filename]
  }
  filename                       = "process-jpeg-images.zip"
  memory_size                    = 128
  package_type                   = "Zip"
  reserved_concurrent_executions = -1
  role                           = aws_iam_role.S3-Role.arn
  runtime                        = "python3.7"
  source_code_hash               = filebase64sha256("process-jpeg-images.zip")
  tags = {
    "name" = "s3-get-object-python"
  }
  
  timeout = 3

  environment {
    variables = {
      "Bucket_B" = tolist(var.s3_bucket_names)[1]
    }
  }

  timeouts {}

  tracing_config {
    mode = "PassThrough"
  }
}

# S3 permission to aws_lambda_function.process-jpeg-images 
resource "aws_lambda_permission" "s3_access_lambda" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.process-jpeg-images.arn
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${tolist(var.s3_bucket_names)[0]}/*"

  depends_on = [
    aws_lambda_function.process-jpeg-images
  ]
}