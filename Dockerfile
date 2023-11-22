# Use an official Python runtime as a parent image
FROM python:3.12-slim

# `DJANGO_ENV` arg is used to make prod / dev builds:
ARG DJANGO_ENV \
  # Needed for fixing permissions of files created by Docker:
  UID=1000 \
  GID=1000

ENV DJANGO_ENV=${bestweather} \
  PYTHONFAULTHANDLER=1 \
  PYTHONUNBUFFERED=1 \
  PYTHONHASHSEED=random \
  PIP_NO_CACHE_DIR=off \
  PIP_DISABLE_PIP_VERSION_CHECK=on \
  PIP_DEFAULT_TIMEOUT=100 \
  POETRY_VERSION=1.0.0

RUN pip install poetry

# Set the working directory to /app
WORKDIR /bestweather

# Copy the current directory contents into the container at /app
COPY poetry.lock pyproject.toml /bestweather/

# Install any needed packages specified in pyproject.toml

RUN poetry config virtualenvs.create false \
  && poetry install $(test "$YOUR_ENV" == production && echo "--no-dev") --no-interaction --no-ansi

# Make port 80 available to the world outside this container
EXPOSE 80

# Creating folders, and files for a project:
COPY . /bestweather/

# Run your code when the container launches
# CMD ["poetry", "run", "python", "src/your_code_files.py"]