# Phase 3 — Templates & History

**Status:** Complete  
**Date:** 2026-08-08

## Goal

Let users save command property configurations as reusable templates, track copy history, and quickly re-copy recent commands.

## Endpoints added

| Method | Path | Notes |
|--------|------|-------|
| GET | `/api/templates` | Paginated list; optional `command_id` filter; includes command summary |
| GET | `/api/templates/:id` | Single template + command summary |
| POST | `/api/templates` | Save `{ command_id, template_name, property_values, description? }` |
| DELETE | `/api/templates/:id` | Delete template |
| GET | `/api/copy-history` | Last N copies (`limit` default 20, max 20) |
| POST | `/api/copy-history` | Record a copy `{ command_id, copied_command, property_values?, command_template_id? }` |

## Key files

```
backend/
  lib/validatePropertyValues.js
  models/CommandTemplate.js
  models/CopyHistory.js
  controllers/templateController.js
  controllers/copyHistoryController.js
  validators/templateSchemas.js
  validators/copyHistorySchemas.js
  routes/templates.js
  routes/copyHistory.js
frontend/src/
  services/templateService.js
  services/copyHistoryService.js
  hooks/useTemplates.js
  hooks/useCopyHistory.js
  components/SaveTemplateModal.jsx
  components/TemplateCard.jsx
  components/TemplateList.jsx
  components/CopyHistoryItem.jsx
  components/CopyHistoryList.jsx
  pages/TemplatesPage.jsx
  pages/CommandPage.jsx
  context/AppContext.jsx
```

## Design notes

- Templates are **global/shared** (no auth in this app).
- `property_values` stored as PostgreSQL JSONB; validated on backend against command property definitions.
- Copy history trimmed to newest 100 rows in DB; UI shows last 20.
- Copy history state lives in Context API for cross-page access (CommandPage writes, TemplatesPage reads).

## Verification checklist

- [x] Backend modules load without errors
- [x] Frontend production build succeeds (`vite build`)
- [ ] Manual end-to-end: save template from CommandPage
- [ ] Manual end-to-end: load template pre-fills PropertyForm
- [ ] Manual end-to-end: delete template from Templates page
- [ ] Manual end-to-end: copy records history entry
- [ ] Manual end-to-end: re-copy from history
