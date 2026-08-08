function formatRelative(value) {
  if (!value) return '';
  const date = new Date(value);
  const diffMs = Date.now() - date.getTime();
  const diffMin = Math.floor(diffMs / 60000);

  if (diffMin < 1) return 'Just now';
  if (diffMin < 60) return `${diffMin}m ago`;

  const diffHr = Math.floor(diffMin / 60);
  if (diffHr < 24) return `${diffHr}h ago`;

  const diffDay = Math.floor(diffHr / 24);
  if (diffDay < 7) return `${diffDay}d ago`;

  return date.toLocaleDateString(undefined, {
    month: 'short',
    day: 'numeric',
  });
}

function truncate(text, max = 120) {
  if (!text || text.length <= max) return text;
  return `${text.slice(0, max)}…`;
}

export default function CopyHistoryItem({ entry, onRecopy, onOpen, copying = false }) {
  const commandName = entry.command?.name || `Command #${entry.command_id}`;

  return (
    <article className="glass rounded-2xl p-4 sm:p-5">
      <div className="flex flex-wrap items-start justify-between gap-3">
        <div className="min-w-0 flex-1">
          <div className="flex flex-wrap items-center gap-2">
            <h4 className="font-mono text-sm font-semibold text-slate-900 dark:text-white">
              {commandName}
            </h4>
            {entry.template?.template_name && (
              <span className="rounded-md border border-slate-200 bg-slate-100 px-2 py-0.5 text-[11px] text-slate-500 dark:border-white/5 dark:bg-ink-800/60 dark:text-slate-400">
                {entry.template.template_name}
              </span>
            )}
          </div>
          <pre className="mt-2 overflow-x-auto whitespace-pre-wrap break-all font-mono text-xs leading-relaxed text-slate-600 dark:text-slate-300">
            {truncate(entry.copied_command)}
          </pre>
          <p className="mt-2 text-xs text-slate-500">{formatRelative(entry.copied_at)}</p>
        </div>

        <div className="flex shrink-0 gap-2">
          <button
            type="button"
            onClick={() => onRecopy(entry)}
            disabled={copying}
            className="btn-primary px-3 py-1.5 text-xs"
          >
            {copying ? 'Copying…' : 'Re-copy'}
          </button>
          <button
            type="button"
            onClick={() => onOpen(entry)}
            className="rounded-xl border border-slate-200 px-3 py-1.5 text-xs font-medium text-slate-600 transition-colors hover:bg-slate-100 dark:border-white/10 dark:text-slate-300 dark:hover:bg-white/[0.06]"
          >
            Open
          </button>
        </div>
      </div>
    </article>
  );
}
