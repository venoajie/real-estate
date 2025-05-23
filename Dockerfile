# Stage 1: Builder
FROM python:3.12-slim as builder
WORKDIR /app
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential libpq-dev && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --user -r requirements.txt

# Stage 2: Runtime
FROM python:3.12-slim as dev
WORKDIR /app

# Copy Python dependencies
COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH \
    PYTHONPATH=/app \
    DJANGO_SETTINGS_MODULE=real_estate.settings.development

# Install runtime dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends postgresql-client netcat && \
    rm -rf /var/lib/apt/lists/*

# Copy application
COPY . .

# Add wait script
COPY wait-for-db.sh /app/
RUN chmod +x wait-for-db.sh

EXPOSE 8000

CMD ["./wait-for-db.sh", "sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]