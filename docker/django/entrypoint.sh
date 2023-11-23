#!/bin/bash

# Apply database migrations
python manage.py migrate

exec "$@"