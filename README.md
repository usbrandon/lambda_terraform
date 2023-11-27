# AWS Lambda Function Development and Deployment Harness

## Overview
This project aims to streamline the process of developing and deploying an AWS Lambda function using Python 3.11. The function is configured for logging in CloudWatch and is triggered by an EventBridge event on a set schedule.

## Terraform Configuration Breakdown
Terraform reads all `.tf` files simultaneously, understanding how each component fits into the infrastructure.

### `provider.tf`
- **Region**: Specifies `us-east-1` as the AWS region.
- **Profile**: Uses `acloudguru` as the default AWS credentials profile, set up via `aws configure --profile acloudguru`.

### `lambda.tf`
- Manages the packaging and deployment of the Lambda function using a zip file from the `code` folder.

### `iam.tf`
- Defines the IAM role assumed by the Lambda function, granting necessary permissions including CloudWatch logs access.

### `eventbridge.tf`
- Sets up an EventBridge event to trigger the Lambda function every 2 minutes.

### `s3.tf`
- Configures an S3 bucket for storing output files in Parquet format using Polars.

### `variables.tf`
- Centralizes the definition of project-wide variables.

### `terraform.tfvars`
- Provides a single file to set default values for variables defined in `variables.tf`.

## Docker and ECR Integration
The Docker image name and ECR repository URI are dynamically generated and must match to comply with ECR's requirements. Relevant scripts output these values to files for the final `terraform apply`.

## Setup and Execution

### Prerequisites
- Ubuntu 22.04 on WSL 2.0 for Windows 11.
- An ACloudGuru AWS Sandbox account for an isolated AWS environment.
- AWS CLI configured with the `acloudguru` profile.

### Common Issues
- **Clock Sync**: Authentication issues may arise if the Ubuntu clock is out of sync with the hardware clock.
- **AWS Credentials**: Using AWS credential profiles helps avoid accidental modifications to other AWS environments.

### Steps to Set Up and Deploy

1. **Establish Dependencies**:

2. **Remove Stale State Files** (due to temporary AWS environments by Acloud.guru):
   ```
   ./delete_tfstate_files.sh
   ```
3. **Deployment Process**:
- Sync Ubuntu Clock with Hardware Clock:
  ```
  ./1_sync_ubuntu_clock_with_hardware_clock.sh
  ```
- Configure AWS ACloudGuru Profile:
  ```
  ./2_configure_aws_acloudguru_profile.sh
  ```
- Create ECR Repository and Populate `terraform.tfvars`:
  ```
  ./3_create_ecr_repository_and_populate_terraform_tfvars.sh
  ```
- Build and Push Docker Function Image to ECR:
  ```
  ./4_build_and_push_docker_function_image_to_ecr.sh
  ```
- Terraform Plan and Apply:
  ```
  ./5_terraform_plan_and_apply.sh
  ```

