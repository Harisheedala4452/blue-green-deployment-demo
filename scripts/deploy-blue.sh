#!/usr/bin/env bash
set -euo pipefail

echo "Building and starting blue deployment..."
docker compose up -d --build blue nginx
docker compose exec nginx nginx -s reload
echo "Blue deployment is running."
