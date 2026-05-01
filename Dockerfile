FROM python:3.12-slim

LABEL org.opencontainers.image.title="blue-green-deployment-demo" \
  org.opencontainers.image.description="Flask app image used by blue and green deployment slots."

ENV PYTHONDONTWRITEBYTECODE=1 \
  PYTHONUNBUFFERED=1 \
  PORT=5000

WORKDIR /app

# Install dependencies before app code so Docker can reuse this layer.
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip \
  && pip install --no-cache-dir -r requirements.txt

COPY app/ ./app/

# Run as non-root to reduce container privileges.
RUN adduser --disabled-password --gecos "" --uid 10001 appuser \
  && chown -R appuser:appuser /app
USER appuser

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:5000/health', timeout=2).read()" || exit 1

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "--threads", "2", "app.main:app"]
