#!/bin/bash
set -e

# Verify settings
if [ ! -f "real_estate/settings/development.py" ]; then
  echo "Error: Missing development.py settings file" >&2
  exit 1
fi

# Wait for PostgreSQL
until PGPASSWORD=$POSTGRES_PASSWORD psql -h db -U $POSTGRES_USER -d $POSTGRES_DB -c '\q'; do
  >&2 echo "PostgreSQL is unavailable - sleeping"
  sleep 2
done

# Apply migrations
python manage.py migrate

# Start server
exec python manage.py runserver 0.0.0.0:8000 --noreload