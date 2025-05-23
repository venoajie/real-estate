#!/bin/bash
docker build -t real-estate:latest .
docker tag real-estate:latest your-registry/real-estate:$VERSION