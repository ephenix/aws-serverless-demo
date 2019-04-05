resource "aws_cognito_user_pool" "user_pool" {
    name = "user-pool-${random_string.resource-suffix.result}"
    auto_verified_attributes = ["email"] 
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
    name = "user-pool-client-${random_string.resource-suffix.result}"
    user_pool_id = "${aws_cognito_user_pool.user_pool.id}"
    generate_secret = false
}