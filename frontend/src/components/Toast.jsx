import { useApp } from '../context/AppContext';

const ICONS = {
  success: (
    <svg className="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <path d="M20 6 9 17l-5-5" />
    </svg>
  ),
  error: (
    <svg className="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
      <path d="M18 6 6 18M6 6l12 12" />
    </svg>
  ),
};

export default function Toast() {
  const { toasts, dismissToast } = useApp();

  if (!toasts.length) return null;

  return (
    <div className="pointer-events-none fixed bottom-5 right-5 z-50 flex w-80 flex-col gap-2.5">
      {toasts.map((toast) => (
        <div
          key={toast.id}
          className="pointer-events-auto flex animate-toast-in items-center gap-3 rounded-xl border border-slate-200 bg-white/95 px-4 py-3 shadow-lg backdrop-blur-xl dark:border-white/10 dark:bg-ink-850/90 dark:shadow-card"
        >
          <span
            className={`flex h-8 w-8 shrink-0 items-center justify-center rounded-lg ${
              toast.type === 'error'
                ? 'bg-red-500/15 text-red-500 dark:text-red-300'
                : 'bg-emerald-500/15 text-emerald-600 dark:text-emerald-300'
            }`}
          >
            {ICONS[toast.type] || ICONS.success}
          </span>
          <span className="flex-1 text-sm text-slate-700 dark:text-slate-200">{toast.message}</span>
          <button
            type="button"
            onClick={() => dismissToast(toast.id)}
            className="shrink-0 text-slate-400 transition-colors hover:text-slate-700 dark:hover:text-slate-200"
            aria-label="Dismiss"
          >
            <svg className="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
              <path d="M18 6 6 18M6 6l12 12" />
            </svg>
          </button>
        </div>
      ))}
    </div>
  );
}
