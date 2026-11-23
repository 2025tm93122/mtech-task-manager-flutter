#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

ENV_FILE=".back4app.env"

if [ ! -f "$ENV_FILE" ]; then
  echo "ERROR: $ENV_FILE not found."
  echo "Run:"
  echo "cp .back4app.env.example .back4app.env"
  exit 1
fi

# shellcheck disable=SC1090
source "$ENV_FILE"

: "${PARSE_APP_ID:?PARSE_APP_ID is required}"
: "${PARSE_SERVER_URL:?PARSE_SERVER_URL is required}"

PARSE_CLIENT_KEY="${PARSE_CLIENT_KEY:-}"
PARSE_LIVE_QUERY_URL="${PARSE_LIVE_QUERY_URL:-}"
STUDENT_EMAIL_DOMAIN="${STUDENT_EMAIL_DOMAIN:-}"

DEVICE_ARGS=()

if [ "$#" -gt 0 ] && [ -n "${1:-}" ]; then
  DEVICE_ARGS=(-d "$1")
fi

flutter run "${DEVICE_ARGS[@]}" \
  --dart-define="PARSE_APP_ID=$PARSE_APP_ID" \
  --dart-define="PARSE_CLIENT_KEY=$PARSE_CLIENT_KEY" \
  --dart-define="PARSE_SERVER_URL=$PARSE_SERVER_URL" \
  --dart-define="PARSE_LIVE_QUERY_URL=$PARSE_LIVE_QUERY_URL" \
  --dart-define="STUDENT_EMAIL_DOMAIN=$STUDENT_EMAIL_DOMAIN"