variable "rest_api_id" {
    description = "The id of the aws_api_gateway_rest_api."
}
variable "resource_id" {
    description = "The id of the aws_api_gateway_resource."
}

variable "authorizer_id" {
    description = "The id of the aws_api_gateway_authorizer."
}

variable "lambda_arn" {
    description = "The arn of the lambda function"
}

variable "region" {
    description = "The region of the lambda function"
}

variable "method" {
    description = "The http method. GET|PATCH|POST|PUT|DELETE"
}

variable "execution_arn" {
    description = "The execution arn of the rest api."
}

variable "resource_path" {
  description = "The path of the resource."
}