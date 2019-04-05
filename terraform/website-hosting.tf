resource "aws_s3_bucket" "site_bucket" {
    # s3 bucket for static html, js, and css
    bucket = "serverless-web-bucket-${random_string.resource-suffix.result}"
    acl    = "public-read"
    website {
       index_document = "index.html" 
    }
    force_destroy = true
}

resource "aws_s3_bucket_policy" "site_bucket_policy" {
  bucket = "${aws_s3_bucket.site_bucket.bucket}"
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow", 
            "Principal": "*", 
            "Action": "s3:GetObject", 
            "Resource": "arn:aws:s3:::${aws_s3_bucket.site_bucket.bucket}/*" 
        } 
    ] 
}
POLICY
}

resource "null_resource" "sync_static_content" {
    # this copies the static content from the tutorial s3 bucket.
  provisioner "local-exec" {
    command = "aws s3 sync s3://wildrydes-us-east-1/WebApplication/1_StaticWebHosting/website s3://${aws_s3_bucket.site_bucket.bucket} --region ${var.region}"
  }
}