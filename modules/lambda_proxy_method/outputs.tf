output "rest_api_id" {
    value = "${var.rest_api_id}"
    depends_on = [
        "aws_api_gateway_integration.integration",
        "aws_api_gateway_integration_response.integration_response",
        "aws_api_gateway_method_response.method_response"
    ]
}