const ICON_PATHS = {
  database: (
    <>
      <ellipse cx="12" cy="5" rx="8" ry="3" />
      <path d="M4 5v6c0 1.66 3.58 3 8 3s8-1.34 8-3V5" />
      <path d="M4 11v6c0 1.66 3.58 3 8 3s8-1.34 8-3v-6" />
    </>
  ),
  leaf: (
    <path d="M11 20A7 7 0 0 1 9.8 6.1C15.5 5 17 4.48 19 2c1 2 2 4.18 2 8 0 5.5-4.78 10-10 10Z" />
  ),
  zap: <path d="M13 2 3 14h7l-1 8 10-12h-7l1-8Z" />,
  box: (
    <>
      <path d="m21 8-9-5-9 5 9 5 9-5Z" />
      <path d="M3 8v8l9 5 9-5V8" />
      <path d="M12 13v8" />
    </>
  ),
  compass: (
    <>
      <circle cx="12" cy="12" r="9" />
      <path d="m14.5 9.5-2 5-5 2 2-5 5-2Z" />
    </>
  ),
  cloud: <path d="M17.5 19H8a5 5 0 1 1 1.3-9.8A6 6 0 0 1 21 11.5a3.5 3.5 0 0 1-3.5 3.5Z" />,
  gitbranch: (
    <>
      <line x1="6" y1="3" x2="6" y2="15" />
      <circle cx="18" cy="6" r="3" />
      <circle cx="6" cy="18" r="3" />
      <path d="M18 9a9 9 0 0 1-9 9" />
    </>
  ),
  terminal: (
    <>
      <polyline points="4 17 10 11 4 5" />
      <line x1="12" y1="19" x2="20" y2="19" />
    </>
  ),
  activity: <polyline points="22 12 18 12 15 21 9 3 6 12 2 12" />,
  tag: (
    <>
      <path d="M12 2 2 12l10 10 10-10-10-10Z" />
      <circle cx="12" cy="8" r="1.5" fill="currentColor" stroke="none" />
    </>
  ),
};

export default function CategoryIcon({ icon, className = 'h-5 w-5' }) {
  const path = ICON_PATHS[icon?.toLowerCase()] || ICON_PATHS.tag;

  return (
    <svg
      className={className}
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="1.8"
      strokeLinecap="round"
      strokeLinejoin="round"
      aria-hidden="true"
    >
      {path}
    </svg>
  );
}

export const CATEGORY_ICON_KEYS = Object.keys(ICON_PATHS).filter((k) => k !== 'tag');
