# Dockerfile : Configuration to build Image

# Base Image
FROM python:3.11-alpine
# Labeling for this configuration maintainer
LABEL maintainer="kwon.com"

# Setting the Dcoker file evironment variable
ENV PYTHONUNBUFFERED 1

# COPY : move from "Local files" to "Image layer file system"
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
# WORKDIR: Setting working directory
WORKDIR /app
# EXPOSE: Setting container port
EXPOSE 8000

ARG DEV=false

# Run configurations
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true"]; \
      then /py/pip install -r /tmp/requirements.dev.txt; \
    fi && \
    rm -rf /tmp && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/py/bin:$PATH"

USER django-user
