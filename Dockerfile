# Use ARM-compatible Python base image
FROM --platform=linux/arm64 python:3.12-bookworm

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    DJANGO_SETTINGS_MODULE=real_estate.settings.development

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    postgresql-client libpq-dev && \
    rm -rf /var/lib/apt/lists/*

# Set work directory
WORKDIR /app

# Install Python dependencies
COPY requirements/prod.txt .
RUN pip install --no-cache-dir -r prod.txt

# Copy application
COPY . .

# Database wait and migrations
CMD ["sh", "-c", "\
    until PGPASSWORD=$POSTGRES_PASSWORD psql -h db -U $POSTGRES_USER -d $POSTGRES_DB -c '\q'; do \
      echo 'PostgreSQL not ready - sleeping'; \
      sleep 2; \
    done && \
    python manage.py migrate && \
    exec python manage.py runserver 0.0.0.0:8000"]