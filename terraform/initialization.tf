variable "region" {
    default = "us-west-2"
}

provider "aws" {
    region = "${var.region}"
}

resource "random_string" "resource-suffix" {
    # random characters to make resources unique
    length = 6
    special = false
    upper = false
}