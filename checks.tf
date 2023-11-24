#
# Building the lambda environment requires using docker.  Fail out if it is not installed.
#
resource "null_resource" "check_docker" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "docker --version"
    on_failure = fail
  }
}

#resource "null_resource" "lambda_dependencies" {
#  depends_on = [null_resource.check_docker]

  # ... existing configuration ...
#}