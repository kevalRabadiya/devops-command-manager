#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

if [[ -f .env ]]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
fi

: "${DATABASE_URL:?DATABASE_URL is required}"

DUMP_FILE="${ROOT_DIR}/prisma/seed/dump.sql"
PSQL_URL="$(node "${ROOT_DIR}/scripts/db-url.js")"

psql "$PSQL_URL" \
  -v ON_ERROR_STOP=1 \
  -f "$DUMP_FILE"

echo "Seed dump imported from $DUMP_FILE"
