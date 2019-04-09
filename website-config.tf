locals {
  config = <<CONFIG
window._config = {
    cognito: {
        userPoolId: '${aws_cognito_user_pool.user_pool.id}',
        userPoolClientId: '${aws_cognito_user_pool_client.user_pool_client.id}',
        region: '${var.region}'
    },
    api: {
        invokeUrl: "${aws_api_gateway_deployment.deployment.invoke_url}"
    }
};
CONFIG
}

resource "aws_s3_bucket_object" "auth_config" {
  bucket  = "${aws_s3_bucket.site_bucket.bucket}"
  key     = "js/config.js"
  content = "${local.config}"
  etag    = "${md5(local.config)}"
}