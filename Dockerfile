# Multi-stage Dockerfile
FROM python:3.11-slim as base
WORKDIR /app
COPY requirements/ .
RUN pip install --no-cache-dir -r prod.txt

FROM base as dev
RUN pip install -r dev.txt
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

FROM base as prod
COPY . .
CMD ["gunicorn", "core.wsgi:application", "--bind", "0.0.0.0:8000"]