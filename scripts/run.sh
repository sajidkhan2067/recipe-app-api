#!/bin/sh

set -e

# Ensure correct ownership and permissions for /vol/web
echo "Setting permissions for /vol/web..."
mkdir -p /vol/web/media /vol/web/static
chown -R django-user:django-user /vol/web
chmod -R 775 /vol/web

# Run migrations and start the server
echo "Running migrations..."
python manage.py wait_for_db
python manage.py migrate
python manage.py collectstatic --noinput

echo "Starting application..."
exec "$@"
