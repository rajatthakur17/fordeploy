FROM python:3.11

# System dependencies for GUI and audio
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

WORKDIR /app
COPY . .

RUN pip install --upgrade pip
RUN pip install -r requirements.txt

CMD ["xvfb-run", "python", "app.py"]
