
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

# Install runtime dependencies (removed dos2unix)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    postgresql-client \
    curl && \
    rm -rf /var/lib/apt/lists/*

# Copy virtual environment
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH" \
    PYTHONPATH=/app \
    DJANGO_SETTINGS_MODULE=real_estate.settings.development
    
# Copy application (preserve structure)
COPY . .

# Set execute permissions
RUN chmod +x /app/docker-entrypoint.sh

# Ensure proper working directory
WORKDIR /app/src

EXPOSE 8000

CMD ["/app/docker-entrypoint.sh"]
