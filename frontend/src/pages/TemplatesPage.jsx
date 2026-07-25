import PlaceholderPage from '../components/PlaceholderPage';

export default function TemplatesPage() {
  return (
    <PlaceholderPage
      title="Templates"
      description="Save and reuse command configurations so your most common setups are always one click away."
      icon={
        <svg className="h-8 w-8" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
          <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z" />
          <path d="M14 2v6h6M16 13H8M16 17H8M10 9H8" />
        </svg>
      }
    />
  );
}
