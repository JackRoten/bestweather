# syntax=docker/dockerfile:1

# Comments are provided throughout this file to help you get started.
# If you need more help, visit the Dockerfile reference guide at
# https://docs.docker.com/engine/reference/builder/

ARG PYTHON_VERSION=3.12
FROM python:${PYTHON_VERSION}-slim as base

# Prevents Python from writing pyc files.
ENV PYTHONDONTWRITEBYTECODE=1

# Keeps Python from buffering stdout and stderr to avoid situations where
# the application crashes without emitting any logs due to buffering.
ENV PYTHONUNBUFFERED=1

ENV POETRY_VERSION=1.1.11
ENV POETRY_CACHE="/nonexistent/.cache/pypoetry/virtualenvs"

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python -

WORKDIR /app

RUN ls -l /app

# Copy only the dependencies files to leverage Docker cache
COPY pyproject.toml poetry.lock /app/

# Create a non-privileged user that the app will run under.
# See https://docs.docker.com/go/dockerfile-user-best-practices/
ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser

# Download dependencies as a separate step to take advantage of Docker's caching.
# Leverage a cache mount to /root/.cache/pip to speed up subsequent builds.
# Leverage a bind mount to requirements.txt to avoid having to copy them into
# into this layer.

RUN pip install --upgrade pip setuptools poetry
RUN poetry config virtualenvs.in-project true && \
    poetry install --only main

# Switch to the non-privileged user to run the application.
USER appuser

# Copy the source code into the container.
COPY . ./

# Expose the port that the application listens on.
EXPOSE 8000

# Run the application.
CMD ["poetry", "run", "python", "manage.py", "runserver", "0.0.0.0:8000"]
