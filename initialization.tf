terraform {
  backend "s3" {
      bucket = "terraform-remote-state-488jfoms"
      key = "aws-serverless-demo.tfstate"
      region = "us-west-2"
      dynamodb_table = "terraform-state-lock"
    }
}

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