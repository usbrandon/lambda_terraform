#!/bin/bash

# Define paths
VENV_DIR="venv"
CODE_DIR="$(pwd)/code"   # Directory where your Lambda function code and requirements.txt are located
LAYER_DIR="$(pwd)/lambda_layers"  # Directory to store layers

# Check if the folder exists
if [ -d "$LAYER_DIR" ]; then
    echo "Found an old $LAYER_DIR exists. Deleting it..."
    rm -rf "$LAYER_DIR"
else
    echo "Checked and found that $LAYER_DIR does not exist."
fi

echo "Creating lambda_layers directory at $LAYER_DIR"
mkdir -p $LAYER_DIR

# Function to package and zip a layer
package_layer() {
    echo "Creating a virtual environment"
    python3.11 -m venv $VENV_DIR
    source $VENV_DIR/bin/activate
    
    PACKAGE_NAME=$1
    LAYER_NAME=$2

    echo "Installing $PACKAGE_NAME without dependencies"
    pip install --no-deps $PACKAGE_NAME

    # Check if installation was successful
    if ! pip freeze | grep $PACKAGE_NAME; then
        echo "Failed to install $PACKAGE_NAME"
        exit 1
    fi

    # Prepare the target directory structure
    TARGET_DIR="${LAYER_DIR}/${LAYER_NAME}/python/lib/python3.11/site-packages"
    echo "Creating directory $TARGET_DIR"
    mkdir -p $TARGET_DIR

    echo "Copying installed packages to $TARGET_DIR"
    # Use rsync to copy
    rsync -av --delete --exclude='pip*' --exclude='setuptools*' $VENV_DIR/lib/python3.11/site-packages/ $TARGET_DIR/

   # Change to the directory that contains $LAYER_NAME
    pushd "${LAYER_DIR}/${LAYER_NAME}"

    # Zip the contents. The '.' refers to the current directory (which is now $LAYER_NAME)
    zip -r "../${LAYER_NAME}_layer.zip" .

    # Go back to the previous directory
    popd

    # Clear site-packages for the next installation
    echo "Cleaning up site-packages"
    rm -rf $VENV_DIR/lib/python3.11/site-packages/*

    # Deactivate and clean up the virtual environment
    echo "Deactivating and cleaning up the virtual environment"
    deactivate
    rm -rf $VENV_DIR
}

# Package pyarrow
package_layer "pyarrow" "pyarrow"

# Package Polars
package_layer "polars" "polars"

# Package your Lambda function code into a ZIP file
cd $CODE_DIR
zip -r "${LAYER_DIR}/lambda_function.zip" lambda_function.py

# Clean up
cd ..

echo "Script completed, layer zips should be in ${LAYER_DIR}/"
