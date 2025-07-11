terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 3.0"
        }
    }
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_s3_bucket" "S3Bucket" {
    bucket = "docutech-files"
}

resource "aws_s3_bucket" "S3Bucket2" {
    bucket = "www.inspecto.ca"
}

resource "aws_s3_bucket" "S3Bucket3" {
    bucket = "docutech-bucket"
}

resource "aws_s3_bucket" "S3Bucket4" {
    bucket = "docutech-staging"
}

resource "aws_s3_bucket" "S3Bucket5" {
    bucket = "serverless-framework-deployments-us-east-2-f6007f23-582f"
}

resource "aws_s3_bucket_policy" "S3BucketPolicy" {
    bucket = "${aws_s3_bucket.S3Bucket4.id}"
    policy = "{\"Version\":\"2008-10-17\",\"Statement\":[{\"Sid\":\"PublicReadGetObject\",\"Effect\":\"Allow\",\"Principal\":\"*\",\"Action\":\"s3:GetObject\",\"Resource\":\"arn:aws:s3:::docutech-staging/*\"},{\"Sid\":\"AllowLambdaAccess\",\"Effect\":\"Allow\",\"Principal\":{\"AWS\":\"arn:aws:iam::456297142581:root\"},\"Action\":[\"s3:GetObject\",\"s3:PutObject\",\"s3:DeleteObject\",\"s3:ListBucket\"],\"Resource\":[\"arn:aws:s3:::docutech-staging\",\"arn:aws:s3:::docutech-staging/*\"]}]}"
}
