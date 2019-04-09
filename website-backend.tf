variable "lambda_function_name" {
  default = "requestUnicorn"
}

resource "aws_dynamodb_table" "dynamodb" {
  name     = "Rides"
  hash_key = "RideId"
  write_capacity = 1
  read_capacity = 1
  attribute {
    name = "RideId"
    type = "S"
  }
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.lambda_function_name}-lambda-exec-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Principal": {
            "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Attach role to Managed Policy
resource "aws_iam_policy_attachment" "lambda-policy-attachment" {
  name       = "${var.lambda_function_name}-lambda-policy"
  roles      = ["${aws_iam_role.lambda_exec_role.id}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "db-write-policy" {
    name = "${var.lambda_function_name}-db-write-policy"
    path = "/"
    policy = <<EOF
{ 
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": "dynamodb:PutItem",
        "Resource": "${aws_dynamodb_table.dynamodb.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "db-write-policy-attachment" {
  name = "${var.lambda_function_name}-db-write-policy-"
  roles = ["${aws_iam_role.lambda_exec_role.id}"]
  policy_arn = "${aws_iam_policy.db-write-policy.arn}"
}


resource "aws_lambda_function" "requestUnicorn" {
    function_name = "${var.lambda_function_name}"
    filename = "resources/${var.lambda_function_name}.zip"
    source_code_hash = "${filebase64sha256("resources/${var.lambda_function_name}.zip")}"
    role ="${aws_iam_role.lambda_exec_role.arn}"
    runtime = "nodejs6.10"
    handler = "${var.lambda_function_name}.handler"
}