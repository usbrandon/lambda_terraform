# Use an appropriate base image
FROM public.ecr.aws/lambda/python:3.11

# Copy function code and requirements
COPY ./code/lambda_function.py ./code/requirements.txt ./

# Install dependencies
RUN pip install -r requirements.txt

# Set the CMD to your handler
CMD ["lambda_function.lambda_handler"]
