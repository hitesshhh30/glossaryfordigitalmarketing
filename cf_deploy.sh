#!/bin/bash

# Set variables
CONFIG_FILE="config.yaml"

# Function to read values from YAML file
read_yaml() {
    local key=$1
    grep "^$key:" "$CONFIG_FILE" | sed "s/^$key:[[:space:]]*//"
}

# Check if Wrangler is installed
if ! command -v wrangler &> /dev/null
then
    echo "Wrangler CLI is not installed. Please install it first."
    echo "You can install it using: npm install -g wrangler"
    exit 1
fi

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Configuration file not found. Please make sure config.yaml exists in the current directory."
    exit 1
fi

# Read configuration from YAML file
PROJECT_NAME=$(read_yaml "projectName")
OUTPUT_DIR=$(read_yaml "outputDir")

# Check if project name and output directory are set
if [ -z "$PROJECT_NAME" ] || [ -z "$OUTPUT_DIR" ]; then
    echo "Failed to read projectName or outputDir from config.yaml"
    exit 1
fi

# Check if output directory exists
if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Output directory not found. Please make sure your static files are in the $OUTPUT_DIR directory."
    exit 1
fi

# Deploy to Cloudflare Pages
echo "Deploying to Cloudflare Pages..."
wrangler pages deploy "$OUTPUT_DIR" --project-name="$PROJECT_NAME"

# Check if deployment was successful
if [ $? -eq 0 ]; then
    echo "Deployment successful!"
else
    echo "Deployment failed. Please check the error messages above."
fi