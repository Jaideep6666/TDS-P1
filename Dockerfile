# Use an official Debian-based Python image as the base image
FROM python:3.10-slim-bullseye

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    DATA_DIR=/data \
    AIPROXY_TOKEN="" 

# Create the /data directory and set permissions
RUN mkdir -p ${DATA_DIR} && chmod -R 755 ${DATA_DIR}

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    build-essential \
    libssl-dev \
    libffi-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    nodejs \
    npm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and npx globally
RUN npm install -g npx prettier

# Install Python dependencies dynamically
RUN pip install --no-cache-dir \
    fastapi \
    uvicorn \
    requests \
    markdown \
    GitPython \
    easyocr \
    SpeechRecognition \
    pydub \
    bs4 \
    lxml \
    openai \
    duckdb

# Set the working directory inside the container
WORKDIR /app

# Copy the app.py file into the container
COPY app.py .

# Expose the port the app runs on
EXPOSE 8000

# Command to run the application
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
