# Dockerfile (root)
# syntax=docker/dockerfile:1.7

############################
# Builder: compile wheels
############################
FROM python:3.12-slim AS builder
WORKDIR /app

# OS build deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential libpq-dev \
 && rm -rf /var/lib/apt/lists/*

# Faster, reproducible installs
ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1

COPY requirements.txt .
RUN pip wheel --wheel-dir /wheels -r requirements.txt

############################
# Final: minimal runtime
############################
FROM python:3.12-slim
WORKDIR /app

# Only runtime libs (no compilers)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
 && rm -rf /var/lib/apt/lists/*

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Create non-root user
RUN useradd -m -u 10001 appuser
USER appuser

# Copy wheels and install
COPY --from=builder /wheels /wheels
RUN pip install --no-cache-dir /wheels/*

# Copy *only* the app code you need
# (assumes your code is in ./src and you have a pyproject or similar)
COPY src/ ./src/
# If you have static assets/templates, copy them selectively:
# COPY templates/ templates/
# COPY static/ static/

# Expose and default command (adjust module:app)
EXPOSE 8000
CMD ["python", "-m", "uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000"]
