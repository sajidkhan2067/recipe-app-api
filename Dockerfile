FROM python:3.9-alpine3.13
LABEL maintainer="sajid"

ENV PYTHONUNBUFFERED 1

# Copy requirements
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./scripts /scripts
COPY ./app /app

WORKDIR /app
EXPOSE 8000

ARG DEV=false

# Install dependencies
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client jpeg-dev && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev zlib zlib-dev linux-headers && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; then /py/bin/pip install -r /tmp/requirements.dev.txt; fi && \
    rm -rf /tmp && \
    apk del .tmp-build-deps

# Create Django user
RUN adduser --disabled-password --no-create-home django-user

# Ensure directories exist and set proper permissions
RUN mkdir -p /vol/web/media /vol/web/static && \
    chown -R django-user:django-user /vol/web && \
    chmod -R 775 /vol/web

# Make scripts executable
RUN chmod -R +x /scripts

# Set environment paths
ENV PATH="/scripts:/py/bin:$PATH"

# Switch to non-root user
USER django-user

# Default command
CMD ["run.sh"]
