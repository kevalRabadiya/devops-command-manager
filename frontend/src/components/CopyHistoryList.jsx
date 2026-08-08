import CopyHistoryItem from './CopyHistoryItem';

export default function CopyHistoryList({
  history = [],
  loading,
  error,
  onRecopy,
  onOpen,
  copyingId,
}) {
  if (loading) {
    return (
      <div className="flex items-center gap-3 py-12 text-slate-500 dark:text-slate-400">
        <span className="h-4 w-4 animate-spin rounded-full border-2 border-brand-400 border-t-transparent" />
        Loading copy history…
      </div>
    );
  }

  if (error) {
    return (
      <div className="rounded-2xl border border-red-500/30 bg-red-500/10 p-6 text-red-600 dark:text-red-300">
        {error}
      </div>
    );
  }

  if (!history.length) {
    return (
      <div className="rounded-2xl border border-dashed border-slate-300 bg-slate-50/50 p-10 text-center dark:border-white/10 dark:bg-white/[0.02]">
        <p className="text-sm text-slate-500 dark:text-slate-400">
          No copy history yet. Copy a command from its detail page to see it here.
        </p>
      </div>
    );
  }

  return (
    <div className="space-y-3">
      {history.map((entry) => (
        <CopyHistoryItem
          key={entry.id}
          entry={entry}
          onRecopy={onRecopy}
          onOpen={onOpen}
          copying={copyingId === entry.id}
        />
      ))}
    </div>
  );
}
