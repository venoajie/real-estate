# ARM-optimized Python base
FROM --platform=linux/arm64 python:3.12-bookworm

# Essential environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    DJANGO_SETTINGS_MODULE=real_estate.settings.development \
    PATH="/usr/lib/postgresql/16/bin:$PATH"

# Install system dependencies with ARM-compatible packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    postgresql-client-16 \
    libpq-dev \
    postgresql-common && \
    rm -rf /var/lib/apt/lists/*

# Configure PostgreSQL client paths
RUN ln -s /usr/lib/postgresql/16/bin/* /usr/local/bin/

WORKDIR /app
COPY requirements/prod.txt .
RUN pip install --no-cache-dir -r prod.txt
COPY . .

# Health check and startup script
CMD exec sh -c "\
    until pg_isready -h db -U \$POSTGRES_USER -d \$POSTGRES_DB; do \
      echo 'Waiting for PostgreSQL...'; \
      sleep 2; \
    done && \
    python manage.py migrate && \
    python manage.py runserver 0.0.0.0:8000"