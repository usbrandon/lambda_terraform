import boto3
import pandas as pd
import io
from awswrangler import s3
import logging

# Set up logging
logger = logging.getLogger()
logger.setLevel(logging.ERROR)

def lambda_handler(event, context):
    df = pd.DataFrame({'Message': ['Hello World']})
    buffer = io.BytesIO()
    df.to_parquet(buffer, index=False)
    buffer.seek(0)

    try:
        s3_client = boto3.client('s3')
        s3_client.upload_fileobj(buffer, 'my-lambda-s3-bucket', 'hello_world.parquet')
    except Exception as e:
        # Log the error
        logger.error(f"Error uploading to S3: {e}")
        raise  # Optionally re-raise the exception if you want the Lambda execution to fail

    return {
        'statusCode': 200,
        'body': 'Successfully processed the record.'
    }
