#!/usr/bin/env bash
set -euo pipefail

STATE_FILE=".active-color"

if [[ ! -f "$STATE_FILE" ]]; then
  echo "No rollback state found. Switch traffic once before running rollback."
  exit 1
fi

previous_color="$(cat "$STATE_FILE")"

case "$previous_color" in
  blue)
    ./scripts/switch-to-blue.sh
    ;;
  green)
    ./scripts/switch-to-green.sh
    ;;
  *)
    echo "Invalid rollback state: $previous_color"
    exit 1
    ;;
esac

echo "Rollback completed to $previous_color."
