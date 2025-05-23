#!/bin/bash
set -e

echo "=== Debug Info ==="
echo "Working directory: $(pwd)"
echo "Contents:"
ls -la
echo "Python path: $PYTHONPATH"
echo "=================="

# Verify settings
python manage.py check --settings=real_estate.settings.development

# Wait for PostgreSQL
until PGPASSWORD=$POSTGRES_PASSWORD psql -h db -U $POSTGRES_USER -d $POSTGRES_DB -c '\q'; do
  >&2 echo "PostgreSQL is unavailable - sleeping"
  sleep 2
done

# Apply migrations
python manage.py migrate

# Start server
exec python manage.py runserver 0.0.0.0:8000 --noreload --settings=real_estate.settings.development