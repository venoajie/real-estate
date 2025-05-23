FROM --platform=linux/arm64 python:3.12-slim

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    DJANGO_SETTINGS_MODULE=real_estate.settings.development

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libpq-dev gcc && \
    postgresql-client \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY requirements/ /app/requirements/
RUN pip install --no-cache-dir -r requirements/prod.txt
COPY . .

CMD exec sh -c "\
    until PGPASSWORD=\"\$POSTGRES_PASSWORD\" psql -h db -U \"\$POSTGRES_USER\" -d \"\$POSTGRES_DB\" -c '\q'; do \
      echo 'Waiting for PostgreSQL...'; \
      sleep 2; \
    done && \
    python manage.py migrate && \
    python manage.py runserver 0.0.0.0:8000"