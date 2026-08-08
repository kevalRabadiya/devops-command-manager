function formatDate(value) {
  if (!value) return '';
  return new Date(value).toLocaleDateString(undefined, {
    month: 'short',
    day: 'numeric',
    year: 'numeric',
  });
}

export default function TemplateCard({ template, onLoad, onDelete, deleting = false }) {
  const commandName = template.command?.name || `Command #${template.command_id}`;

  return (
    <article className="glass-strong rounded-2xl p-4 shadow-sm transition-shadow hover:shadow-md dark:shadow-card sm:p-5">
      <div className="flex flex-wrap items-start justify-between gap-3">
        <div className="min-w-0 flex-1">
          <h4 className="truncate font-semibold text-slate-900 dark:text-white">
            {template.template_name}
          </h4>
          <p className="mt-1 font-mono text-sm text-brand-600 dark:text-brand-300">
            {commandName}
          </p>
          {template.description && (
            <p className="mt-2 line-clamp-2 text-sm text-slate-600 dark:text-slate-400">
              {template.description}
            </p>
          )}
          <div className="mt-3 flex flex-wrap items-center gap-2 text-xs text-slate-500">
            {template.command?.category && (
              <span className="rounded-full border border-brand-400/30 bg-brand-500/10 px-2 py-0.5 text-brand-600 dark:text-brand-200">
                {template.command.category}
              </span>
            )}
            <span>Updated {formatDate(template.updated_at)}</span>
          </div>
        </div>

        <div className="flex shrink-0 gap-2">
          <button
            type="button"
            onClick={() => onLoad(template)}
            className="btn-primary px-3 py-1.5 text-xs"
          >
            Load
          </button>
          <button
            type="button"
            onClick={() => onDelete(template)}
            disabled={deleting}
            className="rounded-xl border border-red-500/30 px-3 py-1.5 text-xs font-medium text-red-600 transition-colors hover:bg-red-500/10 disabled:opacity-50 dark:text-red-300"
          >
            Delete
          </button>
        </div>
      </div>
    </article>
  );
}
