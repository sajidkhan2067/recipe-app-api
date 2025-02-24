#!/bin/sh

set -e  # Exit immediately if a command exits with a non-zero status.

# Ensure correct ownership and permissions for /vol/web
echo "Setting permissions for /vol/web..."
mkdir -p /vol/web/media /vol/web/static
chown -R django-user:django-user /vol/web
chmod -R 775 /vol/web

# Run migrations and collect static files
echo "Running migrations..."
python manage.py wait_for_db
python manage.py migrate
python manage.py collectstatic --noinput

# Start Django application and keep the container running
echo "Starting application..."
exec gunicorn --bind 0.0.0.0:8000 app.wsgi:application --workers=4 --threads=2 --timeout=120
