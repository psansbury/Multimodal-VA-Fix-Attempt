
# Base: use NVIDIA AI Workbench base (the default generated image in Workbench is similar)
# If your project has a specific base image defined by Workbench, you can keep that.
# Otherwise, this generic ubuntu+python base example works with Workbench's build system.
FROM ubuntu:22.04

# ----- System prep -----
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-venv python3-dev \
    git curl ca-certificates \
    build-essential \
    # optional: uncomment next line if you want cmake present as a fallback for ONNX sdists
    # cmake \
    && rm -rf /var/lib/apt/lists/*

# Make python3 the default "python"
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

# AI Workbench user and paths (Workbench sets these; we mirror the env vars to be safe)
ARG NVWB_USERNAME=workbench
ARG NVWB_UID=1000
ARG NVWB_GID=1000
ENV NVWB_USERNAME=${NVWB_USERNAME}
ENV NVWB_UID=${NVWB_UID}
ENV NVWB_GID=${NVWB_GID}
RUN groupadd -g ${NVWB_GID} ${NVWB_USERNAME} || true \
    && useradd -m -u ${NVWB_UID} -g ${NVWB_GID} ${NVWB_USERNAME} || true
USER ${NVWB_USERNAME}

# Workbench build context path (Workbench copies files into /opt/project/build/)
WORKDIR /opt/project

# ----- Copy build inputs from your repo -----
# Expecting these to live in your repo root under ./build/
#   build/preBuild.bash
#   build/requirements.txt
#   build/apt.txt (optional)
COPY --chown=${NVWB_UID}:${NVWB_GID} build/ /opt/project/build/

# ----- Optional: install system packages from apt.txt -----
# If you need system deps (e.g., ffmpeg, cmake), list them in build/apt.txt (one per line).
# If you don't use apt.txt, this step will simply skip.
RUN if [ -f /opt/project/build/apt.txt ]; then \
      echo "Installing apt packages from apt.txt..." && \
      sed -i 's/\r$//' /opt/project/build/apt.txt && \
      grep -v '^\s*$' /opt/project/build/apt.txt > /tmp/apt_clean.txt && \
      sudo apt-get update && \
      sudo xargs -a /tmp/apt_clean.txt apt-get install -y && \
      sudo rm -rf /var/lib/apt/lists/* ; \
    else \
      echo "No apt.txt found; skipping apt package install."; \
    fi

# ----- Normalize line endings & run preBuild.bash -----
# This fixes CRLF issues from Windows and makes the script executable.
RUN sed -i 's/\r$//' /opt/project/build/preBuild.bash && \
    chmod +x /opt/project/build/preBuild.bash && \
    /bin/bash /opt/project/build/preBuild.bash

# ----- Install Python deps (GPU: CUDA 12.1 wheels) -----
# We upgrade pip tooling and then install requirements from your file.
# Using the CUDA 12.1 index ensures GPU-enabled torch/vision/audio wheels are selected.
RUN python -m pip install --upgrade pip setuptools wheel && \
    pip install --user --no-cache-dir \
      --index-url https://download.pytorch.org/whl/cu121 \
      -r /opt/project/build/requirements.txt

# (Optional) If you prefer CPU-only wheels instead, comment the above RUN and use:
# RUN python -m pip install --upgrade pip setuptools wheel && \
#     pip install --user --no-cache-dir \
#       --index-url https://download.pytorch.org/whl/cpu \
#       -r /opt/project/build/requirements.txt

# ----- Default workdir for running the app -----
WORKDIR /
