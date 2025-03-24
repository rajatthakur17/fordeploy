# Use a lightweight official Python image
FROM python:3.11-slim

# Set the working directory inside the container
WORKDIR /app

# Install system-level dependencies
RUN apt-get update && \
    apt-get install -y portaudio19-dev python3-dev gcc && \
    apt-get clean

# Copy requirements.txt and install Python packages
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy all project files into the container
COPY . .

# Expose port 5000 for Flask
EXPOSE 5000

# Command to run your Flask app (change if needed)
CMD ["python", "app.py"]
