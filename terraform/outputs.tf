output "website_url" {
    value = "http://${aws_s3_bucket.site_bucket.website_endpoint}"
}