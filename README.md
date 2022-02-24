# AWS/Terraform/Python Challenge


User should be able upload pictures to an S3 bucket (Bucket_A). These pictures are always in the .jpg format. We wants these files to be stripped from any exif metadata before being shown on their website. The following system will retrieve .jpg files when they are uploaded to the S3 Bucket_A, removes any exif metadata, and saves them to another S3 Bucket_B.

## Deploy

1. Clone this repository

2. Build
```
    cd terraform
    terraform init
    terraform validate
    terraform plan -var-file=image-processor.tfvars
    terraform apply -var-file=image-processor.tfvars
```
