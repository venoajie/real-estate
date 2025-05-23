.PHONY: test migrate run build deploy-monitoring

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