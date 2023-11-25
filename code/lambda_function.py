import boto3
import polars as pl
import io
import logging

# Set up logging
logger = logging.getLogger()
logger.setLevel(logging.ERROR)

def lambda_handler(event, context):
    # Create a Polars DataFrame
    df = pl.DataFrame({'Message': ['Hello World']})

    # Write the DataFrame to a buffer in Parquet format
    buffer = io.BytesIO()
    df.write_parquet(buffer)
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