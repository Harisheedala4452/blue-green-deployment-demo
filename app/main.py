import os
from datetime import datetime, timezone

from flask import Flask, jsonify

app = Flask(__name__)


APP_COLOR = os.getenv("APP_COLOR", "blue")
APP_VERSION = os.getenv("APP_VERSION", "1.0.0")


@app.get("/")
def index():
    """Show which deployment color is serving traffic."""
    return jsonify(
        {
            "message": "Blue-Green Deployment Demo",
            "active_color": APP_COLOR,
            "version": APP_VERSION,
            "endpoints": ["/health", "/version"],
        }
    )


@app.get("/health")
def health():
    """Health endpoint used before switching traffic."""
    return jsonify(
        {
            "status": "ok",
            "color": APP_COLOR,
        }
    )


@app.get("/version")
def version():
    """Return safe runtime metadata for deployment verification."""
    return jsonify(
        {
            "app": "blue-green-deployment-demo",
            "color": APP_COLOR,
            "version": APP_VERSION,
            "hostname": os.getenv("HOSTNAME", "local"),
            "time": datetime.now(timezone.utc).isoformat(),
        }
    )
