# Use official Python image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies required for PyAudio and others
RUN apt-get update && apt-get install -y \
    portaudio19-dev \
    python3-dev \
    build-essential \
    libasound-dev \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy all project files
COPY . .

# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Expose Flask default port
EXPOSE 5000

# Run your app (adjust as needed)
CMD ["python", "app.py"]
