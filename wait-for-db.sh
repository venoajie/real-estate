#!/bin/sh
set -e

# Wait for PostgreSQL
until pg_isready -h db -U ${POSTGRES_USER:-appuser}; do
  echo "Waiting for PostgreSQL..."
  sleep 2
done

# Execute command
exec "$@"