#!/bin/bash

# Initialize an array to store the names of found files
found_files=()

# Function to check for a file's existence
check_file() {
    local file=$1
    if [ -f "$file" ]; then
        echo "File found: $file"
        found_files+=("$file")  # Add file to the array
    else
        echo "File not found: $file"
    fi
}

# Check for terraform.tfstate and terraform.tfstate.backup
check_file "terraform.tfstate"
check_file "terraform.tfstate.backup"

# Ask the user if they want to delete the found files
if [ ${#found_files[@]} -ne 0 ]; then
    echo "The following files were found: ${found_files[*]}"
    read -p "Do you want to delete these files? (yes/no) " answer

    if [ "$answer" = "yes" ]; then
        for file in "${found_files[@]}"; do
            rm "$file"
            echo "$file deleted."
        done
    else
        echo "Files not deleted."
    fi
fi
