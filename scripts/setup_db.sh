#!/bin/bash

# Initialize database
echo "Setting up database..."
docker-compose exec db psql -U postgres -c "CREATE DATABASE real_estate;"
docker-compose exec db psql -U postgres -c "CREATE USER real_estate WITH PASSWORD 'securepassword';"
docker-compose exec db psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE real_estate TO real_estate;"

echo "Running migrations..."
docker-compose exec web python manage.py migrate

echo "Database setup complete"