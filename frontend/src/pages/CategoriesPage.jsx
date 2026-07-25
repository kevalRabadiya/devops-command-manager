import PlaceholderPage from '../components/PlaceholderPage';

export default function CategoriesPage() {
  return (
    <PlaceholderPage
      title="Categories"
      description="Browse and manage command categories across databases, containers, clusters and cloud providers."
      icon={
        <svg className="h-8 w-8" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
          <rect x="3" y="3" width="7" height="7" rx="1.5" />
          <rect x="14" y="3" width="7" height="7" rx="1.5" />
          <rect x="14" y="14" width="7" height="7" rx="1.5" />
          <rect x="3" y="14" width="7" height="7" rx="1.5" />
        </svg>
      }
    />
  );
}
