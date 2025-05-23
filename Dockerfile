# ARM-optimized Python base
FROM --platform=linux/arm64 python:3.12-bookworm

# Essential environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    DJANGO_SETTINGS_MODULE=real_estate.settings.development

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends wget gnupg2 && \
    wget -qO- https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor > /usr/share/keyrings/postgresql.gpg && \
    echo "deb [arch=arm64 signed-by=/usr/share/keyrings/postgresql.gpg] http://apt.postgresql.org/pub/repos/apt/ bookworm-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    postgresql-client-16 \
    libpq-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY requirements/prod.txt .
RUN pip install --no-cache-dir -r prod.txt
COPY . .

# Health check and startup script
CMD sh -c "\
  echo '=> Starting application...'; \
  until pg_isready -h db -U \$POSTGRES_USER; do \
    echo 'Waiting for PostgreSQL...'; \
    sleep 2; \
  done; \
  python manage.py migrate; \
  echo '=> Starting Django server'; \
  exec python manage.py runserver 0.0.0.0:8000"