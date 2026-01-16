FROM docker.io/library/python:3.11-slim

# System deps (incl. Tesseract OCR if you use pytesseract)
RUN apt-get update && apt-get install -y --no-install-recommends git build-essential ffmpeg tesseract-ocr libtesseract-dev libleptonica-dev && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements first for caching
COPY requirements.txt /app/requirements.txt

# Upgrade pip, then install PyTorch/Audio from the official CPU wheel index
RUN python -m pip install --upgrade pip && \
    pip install --no-cache-dir --index-url https://download.pytorch.org/whl/cpu \
        torch==2.3.1 torchaudio==2.3.1
# If you added torchvision above, install it here with the same index:
# RUN pip install --no-cache-dir --index-url https://download.pytorch.org/whl/cpu torch==2.3.1 torchaudio==2.3.1 torchvision==0.18.1

# Remove any torch* lines from requirements, then install the rest
RUN sed -i -E 's/^\s*(torch(torchvision|audio)?).*$//g' /app/requirements.txt && \
    pip install --no-cache-dir -r /app/requirements.txt

# Copy application code last
COPY . /app

# Default command (overridden at run-time below if using Uvicorn)
CMD ["python","main.py"]
