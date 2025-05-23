# Stage 1: Builder with virtual environment
FROM python:3.12-slim as builder
WORKDIR /app
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev && \
    rm -rf /var/lib/apt/lists/*

# Create virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install dependencies
COPY requirements/prod.txt .
RUN pip install --no-cache-dir -r prod.txt

# Stage 2: Development
FROM python:3.12-slim as dev
WORKDIR /app

# Copy virtual environment
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH" \
    PYTHONPATH=/app \
    DJANGO_SETTINGS_MODULE=real_estate.settings.development

# Install runtime dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    postgresql-client \
    netcat-openbsd \
    curl \
    dos2unix && \
    rm -rf /var/lib/apt/lists/*

# Copy application
COPY . .

# Configure wait script
COPY wait-for-db.sh /app/
RUN chmod +x /app/wait-for-db.sh && \
    dos2unix /app/wait-for-db.sh

    
# Copy entrypoint
COPY docker-entrypoint.sh /app/
RUN chmod +x /app/docker-entrypoint.sh && \
    dos2unix /app/docker-entrypoint.sh

EXPOSE 8000

CMD ["/app/docker-entrypoint.sh"]