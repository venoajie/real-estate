#!/bin/bash
set -e

# Wait for PostgreSQL
./wait-for-db.sh db

# Apply migrations
python manage.py migrate

# Start server (with --noreload to prevent background thread)
exec python manage.py runserver 0.0.0.0:8000 --noreload