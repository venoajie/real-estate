.PHONY: test migrate run build deploy-monitoring

RUN find /app/deployment/ /app/scripts/ /app/monitoring/ -type f -name "*.sh" -exec chmod +x {} \;

# Development
install:
	pip install -r src/requirements/base.txt

test:
	cd src && pytest apps/ --cov=apps

migrate:
	cd src && python manage.py migrate

run:
	cd src && python manage.py runserver

# Docker
build:
	./deployment/build.sh

# Monitoring
deploy-monitoring:
	docker-compose -f monitoring/docker-compose-monitoring.yml up -d

ensure-executable:
    @find deployment/ scripts/ monitoring/ -type f -name "*.sh" | xargs chmod +x
    @echo "All scripts are now executable"

# Add as dependency to other targets
run: ensure-executable
    cd src && python manage.py runserver