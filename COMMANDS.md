# DevOps Command Manager — Commands Cheat Sheet

Quick reference for Docker (Postgres), backend API, ports, and common checks.

Default ports:

| Service    | Port | Notes                          |
|------------|------|--------------------------------|
| API        | 5000 | Express (`backend/`)           |
| Frontend   | 3000 | Vite React (`frontend/`)       |
| PostgreSQL | 5432 | Docker Compose service         |

---

## First-time setup

```bash
# From project root
docker compose up -d

cd backend
cp .env.example .env
npm install
npm run db:migrate
npm run db:seed
npm run dev

# New terminal
cd frontend
cp .env.example .env
npm install
npm run dev
```

Open http://localhost:3000 (API on http://localhost:5000).

---

## Docker (PostgreSQL)

Run all commands from the **project root** (`command-manager/`).

### Start / stop / restart

```bash
# Start Postgres in background
docker compose up -d

# Stop containers (keeps data volume)
docker compose stop

# Start again after stop
docker compose start

# Restart Postgres
docker compose restart

# Stop and remove containers (keeps named volume)
docker compose down

# Stop, remove containers, and delete DB data volume
docker compose down -v
```

### Status & logs

```bash
# Container status
docker compose ps

# Follow Postgres logs
docker compose logs -f postgres

# Last 100 log lines
docker compose logs --tail=100 postgres
```

### Health & connectivity

```bash
# Is Postgres accepting connections?
docker exec command-manager-db pg_isready -U postgres -d command_manager

# Open interactive psql
docker exec -it command-manager-db psql -U postgres -d command_manager

# Useful SQL once inside psql:
#   SET search_path TO devops_cli;
#   \dt
#   SELECT COUNT(*) FROM commands;
#   \q
```

### Reset / reseed data (destructive to rows)

Schema is managed by Prisma migrations. Sample data comes from a SQL dump only.

```bash
cd backend

# Apply migrations (DDL)
npm run db:migrate

# Truncate tables and import prisma/seed/dump.sql
npm run db:seed

# Export current DB data back into prisma/seed/dump.sql
npm run db:dump
```

To wipe schema entirely and recreate:

```bash
docker exec command-manager-db psql -U postgres -d command_manager \
  -c "DROP SCHEMA IF EXISTS devops_cli CASCADE;"

cd backend
npm run db:migrate
npm run db:seed
```

---

## Backend (Express API)

```bash
cd backend

# Install dependencies (also runs prisma generate)
npm install

# Apply migrations + seed sample data (first time / after wipe)
npm run db:migrate
npm run db:seed

# Dev server (auto-reload with nodemon)
npm run dev

# Production-style start
npm start
```

Env file: `backend/.env` (copy from `.env.example`). Requires `DATABASE_URL` plus `PG*` vars for dump/seed scripts.

| Script | Purpose |
|--------|---------|
| `npm run db:migrate` | Apply Prisma migrations (`prisma migrate deploy`) |
| `npm run db:migrate:dev` | Create/apply migrations in development |
| `npm run db:seed` | Truncate + import `prisma/seed/dump.sql` via `psql` |
| `npm run db:dump` | Export data-only dump into `prisma/seed/dump.sql` via `pg_dump` |

---

## Frontend (Vite + React)

```bash
cd frontend

# Install dependencies
npm install

# Dev server on port 3000
npm run dev

# Production build
npm run build
```

Env file: `frontend/.env` (copy from `.env.example`).

```
VITE_API_BASE_URL=http://localhost:5000/api
```

### Verify frontend

```bash
# Dev server responds
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:3000

# Free port 3000 if stuck
# fuser -k 3000/tcp
```

---

## Verify ports

```bash
# What is listening on API / frontend / Postgres ports?
ss -tlnp | grep -E ':5000|:3000|:5432'

# Or with lsof (if installed)
lsof -i :5000
lsof -i :5432

# Free port 5000 if something is stuck (Linux)
# fuser -k 5000/tcp
```

---

## Verify API

```bash
# Health check
curl -s http://localhost:5000/health

# List commands (paginated)
curl -s "http://localhost:5000/api/commands?page=1&limit=5"

# Search
curl -s "http://localhost:5000/api/commands/search?q=mysqldump"

# Get one command with properties
curl -s http://localhost:5000/api/commands/1

# Create (example)
curl -s -X POST http://localhost:5000/api/commands \
  -H "Content-Type: application/json" \
  -d '{
    "name": "echo-test",
    "description": "Test",
    "command_template": "echo {{message}}",
    "category": "Linux",
    "tags": ["test"]
  }'
```

---

## Typical daily workflow

```bash
# 1. Start DB
docker compose up -d

# 2. Confirm DB ready
docker exec command-manager-db pg_isready -U postgres -d command_manager

# 3. Start API (migrate/seed already done once)
cd backend && npm run dev

# 4. Start frontend (new terminal)
cd frontend && npm run dev

# 5. Confirm
curl -s http://localhost:5000/health
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:3000
```

Phase notes: [docs/phases/](docs/phases/).

---

## Troubleshooting

| Problem | What to try |
|---------|-------------|
| `EADDRINUSE :::5000` | Find/kill process: `ss -tlnp \| grep 5000` then stop that PID |
| `EADDRINUSE :::3000` | Find/kill process: `ss -tlnp \| grep 3000` then stop that PID |
| API can't connect to DB | `docker compose ps` and `pg_isready` as above; check `.env` |
| Frontend can't load commands | Confirm API health + `VITE_API_BASE_URL` in `frontend/.env` |
| Empty / missing tables | `cd backend && npm run db:migrate && npm run db:seed` |
| Port 5432 already in use | Stop local Postgres, or change host port in `docker-compose.yml` |
