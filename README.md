AWS Lambda Function Development and Deployment Harness

What I was setting out to do is break down all of the factors going into
producing an AWS Lambda function using Python 3.11, having logging in CloudWatch,
and setting an EventBridge event to run the lambda function on a set schedule.

All .tf files get read into Terraform simultanously and it figures out how all the pieces fit.

So I broke the project down into tiny parts.
provider.tf
 - Here I specify us-east-1 as the region
 - acloudguru is the default profile that terraform will use for aws credentials
 i.e. you set this up the first time by running aws configure --profile acloudguru

lambda.tf
 - This takes care of zipping up the code in the code folder and using the zip file to
   populate the AWS Lambda Function.  Zip files are the norm for that.

iam.tf
 - an AWS Lambda function requires a role to assume for running as something with certain permissions
   including the ability to write to AWS CloudWatch logs etc.

eventbridge.tf
 - this is an AWS scheduler. There I create an event that runs the lambda function every 2 minutes