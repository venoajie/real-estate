# Stage 1: Builder for Python dependencies
FROM python:3.12-slim as builder

WORKDIR /app
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential libpq-dev && \
    rm -rf /var/lib/apt/lists/*

# Create virtual environment
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install dependencies
COPY requirements/ .
RUN pip install --no-cache-dir -r prod.txt

# Stage 2: Development image
FROM python:3.12-slim as dev

WORKDIR /app
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH" \
    DJANGO_SETTINGS_MODULE="real_estate.settings.development"

# Install additional dev dependencies
COPY requirements/ .
RUN pip install --no-cache-dir -r dev.txt

# Copy application code
COPY . .

# Development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

# Stage 3: Production image
FROM python:3.12-slim as prod

WORKDIR /app
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH" \
    DJANGO_SETTINGS_MODULE="real_estate.settings.production" \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Create non-root user
RUN useradd -m appuser && chown -R appuser /app
USER appuser

# Copy application code
COPY --chown=appuser . .

# Gunicorn configuration
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "4", "--threads", "2", "real_estate.wsgi:application"]