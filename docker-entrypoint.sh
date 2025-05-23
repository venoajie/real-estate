#!/bin/bash
set -e

# Wait for PostgreSQL
until PGPASSWORD=$POSTGRES_PASSWORD psql -h db -U $POSTGRES_USER -d $POSTGRES_DB -c '\q'; do
  >&2 echo "PostgreSQL is unavailable - sleeping"
  sleep 2
done

# Apply migrations
python manage.py migrate

# Start server (with --noreload and force stdout logging)
exec python manage.py runserver 0.0.0.0:8000 --noreload --verbosity 3