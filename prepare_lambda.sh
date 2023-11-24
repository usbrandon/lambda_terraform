#!/bin/bash

# Define paths
VENV_DIR="venv"
DEPS_DIR="python"  # Folder for dependencies within the ZIP
LAYER_ZIP="${PWD}/lambda_layer.zip" # Ensure this path is correct
FUNC_ZIP="${PWD}/lambda_function.zip"
CODE_DIR="${PWD}/code"   # Directory where your Lambda function code and requirements.txt are located

# Create a virtual environment
python3.11 -m venv $VENV_DIR
source $VENV_DIR/bin/activate

# Install each dependency individually, excluding numpy
while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ $line != numpy* ]]; then
        pip install --no-deps $line
    fi
done < $CODE_DIR/requirements.txt


# Install pyarrow without its dependencies
pip install --no-deps pyarrow==14.0.1

# Deactivate the virtual environment
deactivate

# Package dependencies into a ZIP file for the Lambda Layer
mkdir -p $DEPS_DIR
cp -r $VENV_DIR/lib/python3.11/site-packages/* $DEPS_DIR/
zip -r $LAYER_ZIP $DEPS_DIR

# Package your Lambda function code into a ZIP file
cd $CODE_DIR
zip -r $FUNC_ZIP lambda_function.py

# Clean up
cd ..
rm -rf $VENV_DIR $DEPS_DIR

echo "Script completed, lambda_layer.zip should be at ${PWD}/lambda_layer.zip"
