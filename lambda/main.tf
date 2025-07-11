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

resource "aws_lambda_permission" "LambdaPermission" {
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.LambdaFunction2.arn}"
    principal = "apigateway.amazonaws.com"
    source_arn = "arn:aws:execute-api:us-east-1:456297142581:dlxpcs8h6j/*/*/test"
}

resource "aws_lambda_permission" "LambdaPermission2" {
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.LambdaFunction2.arn}"
    principal = "apigateway.amazonaws.com"
    source_arn = "arn:aws:execute-api:us-east-1:456297142581:dlxpcs8h6j/*/GET/test"
}

resource "aws_lambda_permission" "LambdaPermission3" {
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.LambdaFunction.arn}"
    principal = "apigateway.amazonaws.com"
    source_arn = "arn:aws:execute-api:us-east-1:456297142581:dlxpcs8h6j/*/*/upload_image"
}

resource "aws_lambda_permission" "LambdaPermission4" {
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.LambdaFunction.arn}"
    principal = "apigateway.amazonaws.com"
    source_arn = "arn:aws:execute-api:us-east-1:456297142581:dlxpcs8h6j/*/POST/upload_image"
}

resource "aws_lambda_permission" "LambdaPermission5" {
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.LambdaFunction.arn}"
    principal = "apigateway.amazonaws.com"
    source_arn = "arn:aws:execute-api:us-east-1:456297142581:dlxpcs8h6j/*/POST/print-postcard"
}

resource "aws_lambda_function" "LambdaFunction" {
    description = ""
    function_name = "upload_image"
    handler = "index.handler"
    architectures = [
        "x86_64"
    ]
    s3_bucket = "prod-04-2014-tasks"
    s3_key = "/snapshots/456297142581/upload_image-e0d954df-4ea6-49df-af11-1dbb6304b5ba"
    s3_object_version = "IG.4iNJaBrCjqqw8IXXnpuQwIw1S.fGf"
    memory_size = 128
    role = "arn:aws:iam::456297142581:role/service-role/upload_image-role-0vn9t44c"
    runtime = "nodejs22.x"
    timeout = 3
    tracing_config {
        mode = "PassThrough"
    }
}

resource "aws_lambda_function" "LambdaFunction2" {
    description = ""
    function_name = "test"
    handler = "index.handler"
    architectures = [
        "x86_64"
    ]
    s3_bucket = "prod-04-2014-tasks"
    s3_key = "/snapshots/456297142581/test-9a6822e3-4eeb-4247-b340-d65f3c404f0e"
    s3_object_version = "BmmX9Zr13NfIpS95_5Ov15N1zcfv_v10"
    memory_size = 128
    role = "arn:aws:iam::456297142581:role/service-role/test-role-fxlat47j"
    runtime = "nodejs22.x"
    timeout = 3
    tracing_config {
        mode = "PassThrough"
    }
}
