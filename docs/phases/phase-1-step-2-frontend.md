# Phase 1 Step 2 — Frontend Structure

**Status:** Complete  
**Date:** 2026-07-24

## Goal

Scaffold a React frontend with routing, Axios services, Context API, Tailwind, and core search/command-detail UI wired to the Phase 1 backend.

## What was built

### Stack

- Vite + React (JS)
- React Router v6
- Axios
- Context API
- Tailwind CSS
- Frontend port: **3000** (matches backend CORS)

### Layout

```
frontend/
  src/
    services/apiClient.js
    services/commandService.js
    context/AppContext.jsx
    hooks/useSearch.js
    hooks/useClipboard.js
    components/ (SearchBar, CommandList, CommandCard, PropertyForm, Layout, Toast)
    pages/ (Search, Command, Categories, Templates, FeatureRequests)
```

### Routes (5 pages)

| Path | Page | Notes |
|------|------|-------|
| `/` | SearchPage | Search + category filter + command grid |
| `/commands/:id` | CommandPage | Detail, property form, live preview, copy |
| `/categories` | CategoriesPage | Placeholder |
| `/templates` | TemplatesPage | Placeholder |
| `/feature-requests` | FeatureRequestsPage | Placeholder |

### Key pieces

- **commandService** — list, search, getById, create, update, remove
- **useSearch** — debounced (~300ms) search / list into AppContext
- **useClipboard** — copy + toast
- **PropertyForm** — dynamic fields by `property_type`; substitutes `{{name}}` in template

### Env

```
VITE_API_BASE_URL=http://localhost:5000/api
```

## How to run

```bash
# Ensure Postgres + backend are up (see Step 1)
cd frontend
cp .env.example .env
npm install
npm run dev
```

Open http://localhost:3000

## UI / UX design (modern refresh)

- **Theme:** dark, terminal-inspired (`ink` palette) with an indigo → violet → cyan brand gradient.
- **Design system:** central tokens in `tailwind.config.js` (colors, shadows `glow`/`card`, `brand-gradient`, `grid-faint`) and reusable `.glass`, `.glass-strong`, `.btn-primary`, `.input-base`, `.gradient-text` utilities in `src/index.css`.
- **Animations:** keyframes for `fade-up`, `scale-in`, `toast-in`, `float`, `gradient-pan`, `shimmer`; staggered card entrance, hover lift + glow, animated ambient background blobs, skeleton shimmer loaders, animated gradient nav pill. Respects `prefers-reduced-motion`.
- **Components:** glass sticky nav with gradient logo, hero search section, category-colored command cards, terminal-style command preview (traffic-light header, `$` prompt, copy-with-checkmark), toggle switches for boolean properties, icon-based toasts, and a shared animated `PlaceholderPage`.
- **Responsive:** mobile-first; 1 → 2 → 3 column card grid, stacking hero/nav, fluid typography.
- **Light / dark themes:** Tailwind `darkMode: 'class'`; theme stored in `AppContext` (persisted to `localStorage`, falls back to system preference), applied via `dark` class on `<html>`. A no-flash inline script in `index.html` sets the theme before paint. Toggle button (`ThemeToggle.jsx`, animated sun/moon) lives in the nav; all components carry light + `dark:` variants.
- **Footer:** low-opacity "© {year} Keval Rabadiya" copyright line.

## Verification checklist

- [x] Search lists commands from API
- [x] Category filter works
- [x] Command detail loads properties
- [x] Property form updates live command preview
- [x] Copy button shows toast
- [x] All five nav links resolve
- [x] Production build passes (`npm run build`)
- [x] Dev server serves on port 3000
