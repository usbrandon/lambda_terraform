# Use an appropriate base image
FROM public.ecr.aws/lambda/python:3.11

# Copy function code and requirements
COPY ./lambda_function.py ./requirements.txt ./

# Install dependencies
RUN pip install -r requirements.txt

# Set the CMD to your handler
CMD ["lambda_function.lambda_handler"]
