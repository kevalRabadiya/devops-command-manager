#!/usr/bin/env node
/**
 * Normalize Prisma DATABASE_URL for psql/pg_dump.
 * - Drops Prisma-only `schema` query param (causes libpq issues)
 * - Ensures sslmode=require for Neon hosts
 * - Leaves host/port/user/password/db intact from the URL (no separate PGPORT needed)
 */
const raw = process.env.DATABASE_URL;

if (!raw) {
  console.error('DATABASE_URL is required');
  process.exit(1);
}

let url;
try {
  url = new URL(raw);
} catch {
  console.error('DATABASE_URL is not a valid URL');
  process.exit(1);
}

url.searchParams.delete('schema');

const host = url.hostname.toLowerCase();
if (host.includes('neon.tech') && !url.searchParams.has('sslmode')) {
  url.searchParams.set('sslmode', 'require');
}

process.stdout.write(url.toString());
