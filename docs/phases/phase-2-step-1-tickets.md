# Phase 2 Step 1 — Tickets / Feature Requests

**Status:** Complete
**Date:** 2026-07-30

## Goal

Let users submit new command ideas and vote on existing requests, backed by the
already-defined `feature_requests` table.

## Naming note

The original spec called this feature "tickets" (`/api/tickets`,
`TicketForm.jsx`, etc.). The DB table, the `/feature-requests` route, and the
nav link ("Requests") already existed from Phase 1 as `feature_requests`, so
the API and page were built under that name instead of introducing a parallel
"ticket" concept. Component filenames (`TicketForm`, `TicketCard`,
`TicketList`) keep the spec's naming since they're internal implementation
detail.

## Endpoints added

| Method | Path                          | Notes                                  |
|--------|-------------------------------|-----------------------------------------|
| GET    | `/api/feature-requests`       | Paginated, filter by `status`/`category`, sorted by votes then recency |
| POST   | `/api/feature-requests`       | Create a request (`title`, `description` required) |
| PUT    | `/api/feature-requests/:id`   | Admin-style update (status, priority, notes, etc.) |
| POST   | `/api/feature-requests/:id/vote` | `{ direction: 'up' \| 'down' }` |

## Key files

```
backend/
  models/FeatureRequest.js
  controllers/featureRequestController.js
  validators/featureRequestSchemas.js
  routes/featureRequests.js
frontend/src/
  services/featureRequestService.js
  hooks/useFeatureRequests.js
  components/TicketForm.jsx
  components/TicketList.jsx
  components/TicketCard.jsx
  pages/FeatureRequestsPage.jsx
```

## Verification checklist

- [x] Backend modules load without errors (`node -e "require(...)"`)
- [x] Frontend production build succeeds (`vite build`)
- [ ] Manual end-to-end check against a running Postgres instance — no local
      Postgres server was available in the dev sandbox used to build this
      (only `postgresql-client` is installed, no server binaries), so the API
      was verified statically against `schema.prisma` and the generated
      Prisma client types rather than live requests. Run the app locally and
      exercise create/list/vote/update before shipping.
