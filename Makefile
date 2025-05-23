.PHONY: test migrate run
 
test:
    pytest apps/ --cov=apps
 
migrate:
    python manage.py migrate
 
run:
    python manage.py runserver