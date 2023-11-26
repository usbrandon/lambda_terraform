#
# We will store all docker images that contain lambda functions in this repository
#
resource "aws_ecr_repository" "lambda_function_repository" {
  name                 = "lambda_function_repository"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  // Optionally, you can enable encryption with a KMS key
  // encryption_configuration {
  //   encryption_type = "KMS"
  //   kms_key         = "<your-kms-key-arn>"
  // }
}