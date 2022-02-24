resource "aws_s3_bucket" "s3_bucket" {
    for_each = toset(var.s3_bucket_names)
    bucket   = each.key
    acl      = "private"
    tags     ={
        "Name" = each.key
    }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
    for_each = toset(var.s3_bucket_names)
    bucket   = each.key
    policy   = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "",
                "Effect": "Allow",
                "Principal": {
                    "AWS": aws_iam_role.S3-Role.arn
                },
                "Action": [
                    "s3:GetObject",
                    "s3:PutObject"
                ],
                "Resource": "arn:aws:s3:::${each.value}/*"
            }
        ]
    })
    depends_on = [
      aws_s3_bucket.s3_bucket
    ]
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = tolist(var.s3_bucket_names)[0]

  lambda_function {
    lambda_function_arn = aws_lambda_function.process-jpeg-images.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.s3_access_lambda]
}


