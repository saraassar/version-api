FROM python:3.12-slim

WORKDIR /app

# Non-root user — CI will build this, k8s will later enforce
# allowPrivilegeEscalation:false / runAsNonRoot on top of it
RUN useradd --create-home --shell /bin/bash appuser

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ ./app

# CI passes these two at `docker build` time. They become the source of
# truth that /version reports back at runtime.
ARG GIT_SHA=unknown
ARG BUILD_TIME=unknown
ENV GIT_SHA=${GIT_SHA}
ENV BUILD_TIME=${BUILD_TIME}

USER appuser

EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
