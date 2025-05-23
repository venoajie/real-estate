#!/bin/bash
set -e

# Verify Django can find settings
python manage.py check --settings=real_estate.settings.development

# Wait for PostgreSQL
until PGPASSWORD=$POSTGRES_PASSWORD psql -h db -U $POSTGRES_USER -d $POSTGRES_DB -c '\q'; do
  >&2 echo "PostgreSQL is unavailable - sleeping"
  sleep 2
done

# Apply migrations
python manage.py migrate

# Start server (with explicit settings and no reload)
exec python manage.py runserver 0.0.0.0:8000 --noreload --settings=real_estate.settings.development