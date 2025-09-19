# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/vscode/devcontainers/python:3.12

WORKDIR /workspace

# System deps for psycopg2, etc. (trim as needed)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential libpq-dev curl ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Python deps
COPY ../requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# App code
COPY . /workspace
