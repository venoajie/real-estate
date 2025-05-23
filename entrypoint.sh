#!/bin/sh
set -e

# Wait for PostgreSQL
until pg_isready -h db -U ${POSTGRES_USER:-appuser}; do
  echo "Waiting for PostgreSQL..."
  sleep 2
done

# Run migrations
python manage.py migrate

# Start server
exec python manage.py runserver 0.0.0.0:8000