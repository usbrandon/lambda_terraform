#!/bin/bash
terraform apply -target=aws_ecr_repository.lambda_function_repository

# Check if the first file exists and delete it if it does
if [ -f "ecr_repository_uri.auto.tfvars" ]; then
    echo "Deleting ecr_repository_uri.auto.tfvars..."
    rm ecr_repository_uri.auto.tfvars
else
    echo "ecr_repository_uri.auto.tfvars does not exist."
fi
# Check if the second file exists and delete it if it does
if [ -f "image_uri.auto.tfvars" ]; then
    echo "Deleting image_uri.auto.tfvars..."
    rm image_uri.auto.tfvars
else
    echo "image_uri.auto.tfvars does not exist."
fi


# Get the ECR repository URL
repository_uri=$(terraform output -raw ecr_repository_uri)
echo "ECR repository URL: $repository_uri"

# Save the repository URL to a file
echo "ecr_repository_uri = \"$repository_uri\"" > ecr_repository_uri.auto.tfvars
echo "image_uri = \"$repository_uri:latest\"" > image_uri.auto.tfvars