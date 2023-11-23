# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Set environment variables for Python and Poetry
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV POETRY_VERSION=1.7.1

# Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        build-essential \
        libpq-dev \
        tini \
        && rm -rf /var/lib/apt/lists/*

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python -

# Add `poetry` to PATH
# ENV PATH="${PATH}:${POETRY_VENV}/bin"
ENV PATH="$HOME/.local/bin:$PATH"

# Set the working directory in the container
WORKDIR /bestweather

# Copy only the dependencies files to leverage Docker cache
COPY pyproject.toml poetry.lock /bestweather/

#Upgrade pip
RUN pip install --upgrade pip setuptools

# Install project dependencies
# RUN poetry --version
# RUN poetry config --list
# RUN poetry install

# Copy the entire project to the container
COPY . /bestweather

# Expose port 8000 for Django development server
EXPOSE 8000

# Run Django development server
CMD ["poetry", "run", "python", "manage.py", "runserver", "0.0.0.0:8000"]
