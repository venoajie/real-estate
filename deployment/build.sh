#!/bin/bash

# Configuration
APP_NAME="real-estate"
VERSION=$(git rev-parse --short HEAD)
REGISTRY="your-registry.example.com"  # Change to your registry

# Build Docker image
echo "Building Docker image..."
docker build -t $APP_NAME:latest .

# Tag for production
docker tag $APP_NAME:latest $REGISTRY/$APP_NAME:$VERSION
docker tag $APP_NAME:latest $REGISTRY/$APP_NAME:latest

echo "Build complete. Images:"
docker images | grep $APP_NAME