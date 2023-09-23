#!/bin/sh

if [ -f .env ]; then
    echo "Loading environment variables from .env file"
    export $(cat .env | xargs)
fi

python manage.py makemigrations

python manage.py migrate

python manage.py collectstatic --noinput

echo "from django.contrib.auth.models import User; User.objects.create_superuser(
    '$DJANGO_SUPERUSER_USERNAME', '$DJANGO_SUPERUSER_EMAIL', '$DJANGO_SUPERUSER_PASSWORD'
    )" | python manage.py shell

uwsgi --ini /app/larixon.uwsgi.ini
