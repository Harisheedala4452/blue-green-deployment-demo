#!/usr/bin/env bash
set -euo pipefail

target_color="${1:-}"

if [[ "$target_color" != "blue" && "$target_color" != "green" ]]; then
  echo "Usage: $0 blue|green"
  exit 1
fi

current_color="unknown"
if grep -q "blue_app" nginx/active-upstream.conf; then
  current_color="blue"
elif grep -q "green_app" nginx/active-upstream.conf; then
  current_color="green"
fi

echo "Checking $target_color health before switching..."
docker compose exec "$target_color" python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:5000/health', timeout=2).read()"

echo "$current_color" > .active-color

cat > nginx/active-upstream.conf <<EOF
# This file is updated by switch scripts.
proxy_pass http://${target_color}_app;
EOF

docker compose exec nginx nginx -t
docker compose exec nginx nginx -s reload

echo "Traffic switched from $current_color to $target_color."
