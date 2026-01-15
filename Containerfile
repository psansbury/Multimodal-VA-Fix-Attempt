FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1     PYTHONUNBUFFERED=1     PIP_NO_CACHE_DIR=1

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends     build-essential git curl ca-certificates ffmpeg     libglib2.0-0 libgl1     && rm -rf /var/lib/apt/lists/*

COPY code/requirements.txt /tmp/requirements.code.txt
COPY requirements.txt /tmp/requirements.root.txt
RUN python -m pip install --upgrade pip &&     if [ -s /tmp/requirements.code.txt ]; then         pip install -r /tmp/requirements.code.txt;     elif [ -s /tmp/requirements.root.txt ]; then         pip install -r /tmp/requirements.root.txt;     else         echo 'No requirements found; proceeding without pip install';     fi

COPY . /app

CMD [" python,