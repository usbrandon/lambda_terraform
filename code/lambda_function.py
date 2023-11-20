import boto3
def lambda_handler(event, context):
    result = "Hello World"
    # Log the response out to CloudWatch
    print(result)
    
    return {
        'statusCode' : 200,
        'body': result
    }
