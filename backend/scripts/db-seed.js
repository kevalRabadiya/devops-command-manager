#!/usr/bin/env node
/**
 * Apply prisma/seed/dump.sql to the DB in DATABASE_URL.
 * Uses dotenv (so & in Neon URLs works) and psql --single-transaction
 * so SET search_path survives Neon pooler / transaction mode.
 */
require('dotenv').config();

const { spawnSync } = require('child_process');
const path = require('path');

const raw = process.env.DATABASE_URL;
if (!raw) {
  console.error('[db] DATABASE_URL is required');
  process.exit(1);
}

let url;
try {
  url = new URL(raw);
} catch {
  console.error('[db] DATABASE_URL is not a valid URL');
  process.exit(1);
}

url.searchParams.delete('schema');
if (url.hostname.includes('neon.tech') && !url.searchParams.has('sslmode')) {
  url.searchParams.set('sslmode', 'require');
}

const dumpFile = path.join(__dirname, '..', 'prisma', 'seed', 'dump.sql');
const label = `${url.hostname}${url.port ? `:${url.port}` : ''}${url.pathname}`;

console.log(`[db] Seeding ${label} from prisma/seed/dump.sql ...`);

const result = spawnSync(
  'psql',
  [url.toString(), '-v', 'ON_ERROR_STOP=1', '--single-transaction', '-f', dumpFile],
  { stdio: 'inherit', env: process.env }
);

if (result.error) {
  console.error(`[db] Failed to run psql: ${result.error.message}`);
  console.error('[db] Install PostgreSQL client tools (psql) and retry.');
  process.exit(1);
}

if (result.status !== 0) {
  console.error('[db] Seed failed');
  process.exit(result.status || 1);
}

console.log('[db] Seed completed successfully');
