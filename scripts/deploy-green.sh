#!/usr/bin/env bash
set -euo pipefail

echo "Building and starting green deployment..."
docker compose up -d --build green nginx
docker compose exec nginx nginx -s reload
echo "Green deployment is running."
