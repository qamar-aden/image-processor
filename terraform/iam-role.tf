# aws_iam_role.S3-Role:
resource "aws_iam_policy" "S3-List-Get-Put-Delete-Policy" {
  name = "S3-List-Get-Put-Delete-Policy"
  path = "/service-role/"
  policy = jsonencode(
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "",
                "Effect": "Allow",
                "Action": [
                    "s3:PutObject",
                    "s3:GetObject",
                    "s3:ListBucket"
                ],
                "Resource": [
                    "arn:aws:s3:::${tolist(var.s3_bucket_names)[0]}/*",
                    "arn:aws:s3:::${tolist(var.s3_bucket_names)[1]}/*"
                ]
            }
        ]
    }
  )
  tags      = {}
  tags_all  = {}
}

resource "aws_iam_role" "S3-Role" {
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "lambda.amazonaws.com"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
  force_detach_policies = false
  managed_policy_arns = [
    aws_iam_policy.S3-List-Get-Put-Delete-Policy2.arn,
    "arn:aws:iam::224920748233:policy/service-role/AWSLambdaBasicExecutionRole-f5cb1345-ce93-474c-8b5f-e7712345f35d",
    "arn:aws:iam::224920748233:policy/service-role/AWSLambdaS3ExecutionRole-0f0002a3-c206-4036-b083-93c141b83b45"
  ]
  max_session_duration = 3600
  name                 = "S3-Role"
  path                 = "/service-role/"
  tags                 = {}
  tags_all             = {}
}


