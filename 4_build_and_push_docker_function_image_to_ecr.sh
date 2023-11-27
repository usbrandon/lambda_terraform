#!/bin/bash

# Set AWS Profile and Region
AWS_PROFILE=acloudguru
AWS_REGION=us-east-1

# Read the repository name from terraform.tfvars
REPOSITORY_NAME=$(grep 'ecr_repository_name' terraform.tfvars | cut -d '"' -f 2)

echo "Repository Name: $REPOSITORY_NAME"
#
# You can use the AWS CLI to fetch the URI of the ECR repository. 
# Assuming the repository name is known (as it's defined in your Terraform configuration), 
# you can get the repository URI with the following command
#
# Fetch the ECR Repository URI from AWS CLI
#REPOSITORY_URI=$(aws ecr describe-repositories --repository-names $REPOSITORY_NAME --query 'repositories[0].repositoryUri' --output text --region $AWS_REGION --profile $AWS_PROFILE)
REPOSITORY_URI=$(grep 'ecr_repository_uri' ecr_repository_uri.auto.tfvars | cut -d '"' -f 2)

echo "REPOSITORY_URI: $REPOSITORY_URI"

# Read the image URL from image_url.auto.tfvars
IMAGE_URI=$(grep 'image_uri' image_uri.auto.tfvars | cut -d '"' -f 2)

echo "Image URI: $IMAGE_URI"

# Extract only the registry part of the URI
REGISTRY_URI=$(echo $FULL_REPOSITORY_URI | awk -F'/' '{print $1}')

echo "Registry URI: $REGISTRY_URI"

# Build the Docker image
# Note: Specifying the path to the Dockerfile directory
docker build -t $IMAGE_URI ./code/

# Tag the Docker image
#docker tag my-lambda-function:latest $REPOSITORY_URI/my-lambda-function:latest

echo "Image tagged"

# Login to ECR
aws ecr get-login-password --region $AWS_REGION --profile $AWS_PROFILE | docker login --username AWS --password-stdin $REPOSITORY_URI

# Check the exit status of the previous command
if [ $? -ne 0 ]; then
    echo "Docker login to Elastic Container Repository (ECR) failed, exiting the script."
    exit 1
fi

echo "Docker login to Elastic Container Repository (ECR) succeeded."

# Push the Docker image
docker push $IMAGE_URI
# Check the exit status of the previous command
if [ $? -ne 0 ]; then
    echo "Docker push $IMAGE_URI failed, exiting the script."
    exit 1
fi
echo "Docker push $IMAGE_URI succeeded."