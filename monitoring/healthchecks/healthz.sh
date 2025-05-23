#!/bin/bash

# Simple health check script
URL="http://localhost:8000/health/"

response=$(curl -s -o /dev/null -w "%{http_code}" $URL)

if [ $response -eq 200 ]; then
    echo "OK: Service is healthy"
    exit 0
else
    echo "CRITICAL: Service returned $response"
    exit 2
fi