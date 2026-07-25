# DevOps Command Manager — Commands Cheat Sheet

Quick reference for PostgreSQL (local or Neon), backend API, and common checks.

Default ports:

| Service  | Port | Notes                    |
|----------|------|--------------------------|
| API      | 5000 | Express (`backend/`)     |
| Frontend | 3000 | Vite React (`frontend/`) |

Database is **not** Dockerized. Use local PostgreSQL for development, and set `DATABASE_URL` to your Neon connection string for production / Vercel.

---

## First-time setup

### 1. Local PostgreSQL

Install and start Postgres on your machine, then create the database:

```bash
# Example (adjust for your OS / install)
createdb command_manager
# or:
# psql -U postgres -c "CREATE DATABASE command_manager;"
```

### 2. Backend

```bash
cd backend
cp .env.example .env
# Edit DATABASE_URL if your local user/password/host differ
npm install
npm run db:migrate
npm run db:seed
npm run dev
```

### 3. Frontend (new terminal)

```bash
cd frontend
cp .env.example .env
npm install
npm run dev
```

Open http://localhost:3000 (API on http://localhost:5000).

---

## Database URL (local ↔ Neon)

The app and seed/migrate scripts use **only** `DATABASE_URL` in `backend/.env`.

**Local example:**

```
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/command_manager?schema=devops_cli
```

**Neon (production / Vercel) example:**

```
DATABASE_URL=postgresql://USER:PASSWORD@ep-xxxx.region.aws.neon.tech/neondb?sslmode=require&schema=devops_cli
```

For Neon migrations and seed, use the **direct** (non-pooled) connection string from the Neon dashboard so you avoid pooler / port issues. Keep `sslmode=require` and `schema=devops_cli`.

On Vercel, set the same `DATABASE_URL` (and `CORS_ORIGIN=*`) as environment variables for the backend — you do not need separate `PGHOST` / `PGPORT` vars.

### Migrate & seed

```bash
cd backend

npm run db:migrate   # Prisma migrations (DDL)
npm run db:seed      # Import prisma/seed/dump.sql via psql + DATABASE_URL
npm run db:dump      # Export current data back into dump.sql
```

To wipe the app schema and recreate:

```bash
cd backend
# Uses cleaned DATABASE_URL (strips Prisma schema=; adds Neon SSL if needed)
psql "$(node scripts/db-url.js)" -c 'DROP SCHEMA IF EXISTS devops_cli CASCADE;'
npm run db:migrate
npm run db:seed
```

---

## Backend (Express API)

```bash
cd backend

npm install
npm run db:migrate
npm run db:seed
npm run dev          # nodemon
npm start            # production-style
```

Env file: `backend/.env` (copy from `.env.example`).

| Variable       | Purpose |
|----------------|---------|
| `DATABASE_URL` | Postgres connection (local or Neon). Only DB setting you need to change between environments. |
| `CORS_ORIGIN`  | `*` allows all origins (default). Or a comma-separated list of origins. |
| `PORT`         | API port (default `5000`) |

| Script | Purpose |
|--------|---------|
| `npm run db:migrate` | Apply Prisma migrations (`prisma migrate deploy`) |
| `npm run db:migrate:dev` | Create/apply migrations in development |
| `npm run db:seed` | Truncate + import `prisma/seed/dump.sql` via `psql` (reads `DATABASE_URL`) |
| `npm run db:dump` | Export data-only dump into `prisma/seed/dump.sql` via `pg_dump` |

`psql` and `pg_dump` must be installed locally for seed/dump. Seed scripts strip Prisma’s `schema=` query param and add `sslmode=require` for Neon hosts automatically — no separate `PGPORT` required.

---

## Frontend (Vite + React)

```bash
cd frontend
npm install
npm run dev
npm run build
```

Env file: `frontend/.env` (copy from `.env.example`).

```
VITE_API_BASE_URL=http://localhost:5000/api
```

On Vercel (see `vercel.json` rewrites), set:

```
VITE_API_BASE_URL=/api
```

---

## Deploy on Vercel + Neon

1. Create a Neon project and copy the **direct** connection string.
2. Append `?sslmode=require&schema=devops_cli` (or merge with existing query params).
3. From your machine (once), point `backend/.env` at Neon (or export `DATABASE_URL`) and run:
   ```bash
   cd backend && npm run db:migrate && npm run db:seed
   ```
4. In Vercel project settings, set:
   - `DATABASE_URL` = Neon URL (same as above)
   - `CORS_ORIGIN` = `*`
   - `VITE_API_BASE_URL` = `/api` (frontend build)
5. Deploy. Switching environments is only a `DATABASE_URL` change.

---

## Verify API

```bash
curl -s http://localhost:5000/health
curl -s "http://localhost:5000/api/commands?page=1&limit=5"
curl -s "http://localhost:5000/api/commands/search?q=mysqldump"
curl -s http://localhost:5000/api/commands/1
```

---

## Typical daily workflow

```bash
# 1. Ensure local Postgres is running and DATABASE_URL in backend/.env is correct
cd backend && npm run dev

# 2. Frontend (new terminal)
cd frontend && npm run dev

# 3. Confirm
curl -s http://localhost:5000/health
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:3000
```

Phase notes: [docs/phases/](docs/phases/).

---

## Troubleshooting

| Problem | What to try |
|---------|-------------|
| `EADDRINUSE :::5000` | `ss -tlnp \| grep 5000` then stop that PID |
| `EADDRINUSE :::3000` | `ss -tlnp \| grep 3000` then stop that PID |
| API can't connect to DB | Check `DATABASE_URL` in `backend/.env`; confirm Postgres/Neon is reachable |
| Seed fails on Neon / port errors | Use Neon **direct** URL (not pooler); keep host/port inside `DATABASE_URL` only — do not set `PGPORT` |
| Neon SSL errors | Ensure `sslmode=require` in `DATABASE_URL` (seed helper adds it for `*.neon.tech`) |
| Frontend can't load commands | Confirm API health + `VITE_API_BASE_URL` |
| Empty / missing tables | `cd backend && npm run db:migrate && npm run db:seed` |
