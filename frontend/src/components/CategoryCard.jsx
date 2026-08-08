import { useState } from 'react';
import CategoryIcon from './CategoryIcon';
import CategoryForm from './CategoryForm';

export default function CategoryCard({ category, onUpdated, onDelete, deleting = false }) {
  const [editing, setEditing] = useState(false);
  const color = category.color || '#6366F1';

  if (editing) {
    return (
      <article className="glass-strong rounded-2xl p-4 shadow-sm dark:shadow-card sm:p-5">
        <CategoryForm
          category={category}
          onSaved={(updated) => {
            onUpdated?.(updated);
            setEditing(false);
          }}
          onCancel={() => setEditing(false)}
        />
      </article>
    );
  }

  return (
    <article className="animate-fade-up group relative flex flex-col gap-3 rounded-2xl border border-slate-200 bg-white/80 p-5 shadow-sm backdrop-blur-xl transition-all duration-300 hover:-translate-y-1 hover:shadow-glow dark:border-white/10 dark:bg-white/[0.04] dark:shadow-card">
      <div className="flex items-start justify-between gap-2">
        <div className="flex items-center gap-3">
          <span
            className="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl"
            style={{ backgroundColor: `${color}22`, color }}
          >
            <CategoryIcon icon={category.icon} />
          </span>
          <div className="min-w-0">
            <h3 className="truncate font-semibold text-slate-900 dark:text-white">
              {category.name}
            </h3>
            <span className="text-xs text-slate-500 dark:text-slate-400">
              {category.command_count} command{category.command_count === 1 ? '' : 's'}
            </span>
          </div>
        </div>
      </div>

      {category.description && (
        <p className="line-clamp-2 text-sm leading-relaxed text-slate-600 dark:text-slate-400">
          {category.description}
        </p>
      )}

      <div className="mt-auto flex justify-end gap-2 pt-1">
        <button
          type="button"
          onClick={() => setEditing(true)}
          className="rounded-lg border border-slate-200 px-3 py-1.5 text-xs font-medium text-slate-600 transition-colors hover:bg-slate-50 dark:border-white/10 dark:text-slate-300 dark:hover:bg-white/[0.06]"
        >
          Edit
        </button>
        <button
          type="button"
          onClick={() => onDelete(category)}
          disabled={deleting}
          className="rounded-lg border border-red-500/30 px-3 py-1.5 text-xs font-medium text-red-600 transition-colors hover:bg-red-500/10 disabled:opacity-50 dark:text-red-300"
        >
          {deleting ? 'Deleting…' : 'Delete'}
        </button>
      </div>
    </article>
  );
}
