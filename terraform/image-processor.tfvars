s3_bucket_names = ["pre-processed-images","processed-jpeg-images"]

region = "eu-west-1"

lambda_function_name = "process-jpeg-images"

versioning = "false"

user_vars = {
    user-a = {
        user = "User_A"

    }
    user-b = {
        user = "User_B"
    }
}