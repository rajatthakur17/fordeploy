FROM python:3.11

# Install system dependencies for GUI automation and text-to-speech
RUN apt-get update && apt-get install -y \
    portaudio19-dev \
    python3-tk \
    libx11-dev \
    libxtst6 \
    libxss1 \
    libnss3 \
    libcups2 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    xvfb \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy application files to the container
COPY . .

# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Expose the Flask app port
EXPOSE 5000

# Run the Flask app with xvfb-run to handle GUI operations
CMD ["xvfb-run", "python", "app.py"]
