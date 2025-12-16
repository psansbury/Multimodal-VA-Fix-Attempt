#!/bin/bash

RUN python3 -m pip install --upgrade pip setuptools wheel && \
    pip install --user --no-cache-dir --prefer-binary \
      -r /opt/project/build/requirements.txt
