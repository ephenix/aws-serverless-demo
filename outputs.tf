output "website_url" {
    value = "http://${aws_s3_bucket.site_bucket.website_endpoint}"
}

output "api_url" {
    value = "${aws_api_gateway_deployment.deployment.invoke_url}"
}