
FROM python:3.10-slim

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    python3-dev \
    pkg-config \
    libffi-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    libjpeg-dev \
    zlib1g-dev \
    libpng-dev \
    libgl1 \
    ffmpeg \
    git \
 && rm -rf /var/lib/apt/lists/*

# Set work directory
WORKDIR /opt/project

# Copy requirements
COPY requirements.txt /opt/project/requirements.txt

# Upgrade pip and install Python dependencies
RUN python -m pip install --upgrade pip setuptools wheel \
 && pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . /opt/project

CMD ["bash"]
