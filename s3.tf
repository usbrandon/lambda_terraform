locals {
  current_timestamp = formatdate("YYYY-MM-DD-hh-mm-ss", timestamp())
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-lambda-s3-bucket"
}
