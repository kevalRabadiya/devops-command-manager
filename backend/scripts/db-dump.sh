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
TMP_FILE="$(mktemp)"
PSQL_URL="$(node "${ROOT_DIR}/scripts/db-url.js")"

pg_dump "$PSQL_URL" \
  --schema=devops_cli \
  --data-only \
  --format=plain \
  --no-owner \
  --no-privileges \
  --encoding=UTF8 \
  -f "$TMP_FILE"

{
  cat <<'EOF'
-- Seed dump for devops_cli (truncate + data)
-- Regenerated via: npm run db:dump
SET search_path TO devops_cli;

TRUNCATE TABLE
  copy_history,
  command_templates,
  command_properties,
  commands,
  feature_requests,
  categories
RESTART IDENTITY CASCADE;

EOF
  cat "$TMP_FILE"
} > "$DUMP_FILE"

rm -f "$TMP_FILE"
echo "Dump written to $DUMP_FILE"
