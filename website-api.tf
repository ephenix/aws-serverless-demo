resource "aws_api_gateway_rest_api" "rest_api" {
  name        = "requestUnicorn"
  description = "API Gateway requestUnicorn"
}

resource "aws_api_gateway_authorizer" "requestUnicorn" {
  name                   = "requestUnicorn"
  type                   = "COGNITO_USER_POOLS"
  rest_api_id            = "${aws_api_gateway_rest_api.rest_api.id}"
  authorizer_credentials = "${aws_iam_role.lambda_exec_role.arn}"
  provider_arns          = ["${aws_cognito_user_pool.user_pool.arn}"]
}

resource "aws_api_gateway_resource" "ride" {
  rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.rest_api.root_resource_id}"
  path_part   = "ride"
}

module "cors_options_method" "cors" {
    source = "./modules/cors_options_method"
    rest_api_id = "${aws_api_gateway_rest_api.rest_api.id}"
    resource_id = "${aws_api_gateway_resource.ride.id}"
}

module "lambda_proxy_method" "post_ride" {
    source = "./modules/lambda_proxy_method"
    rest_api_id   = "${module.cors_options_method.rest_api_id}"
    execution_arn = "${aws_api_gateway_rest_api.rest_api.execution_arn}"
    resource_id   = "${aws_api_gateway_resource.ride.id}"
    resource_path = "${aws_api_gateway_resource.ride.path_part}"
    authorizer_id = "${aws_api_gateway_authorizer.requestUnicorn.id}"
    lambda_arn    = "${aws_lambda_function.requestUnicorn.arn}"
    region        = "${var.region}"
    method        = "POST"
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = "${module.lambda_proxy_method.rest_api_id}"
  stage_name  = "prod"
}