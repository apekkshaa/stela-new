# Multi-language (Python/JS/C/C++/Java) execution backend
# SECURITY WARNING: This does NOT sandbox untrusted code.
# Do not expose publicly without strong isolation (containers/VMs, network off, strict limits).

FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8080 \
    CODE_EXEC_TIMEOUT_SECONDS=8

# System deps for multi-language execution
# - nodejs: JavaScript
# - gcc/g++: C/C++
# - default-jdk: Java
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    nodejs \
    npm \
    gcc \
    g++ \
    default-jdk \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8080

# Use gunicorn for production-like hosting.
CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:8080", "app:app"]
