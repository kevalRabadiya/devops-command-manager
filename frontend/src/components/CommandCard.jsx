import { Link } from 'react-router-dom';
import { highlightText } from '../utils/commands';

const CATEGORY_ACCENTS = {
  MySQL: 'from-sky-500/15 to-sky-500/5 text-sky-700 ring-sky-500/30 dark:text-sky-300 dark:ring-sky-400/30',
  PostgreSQL: 'from-blue-500/15 to-blue-500/5 text-blue-700 ring-blue-500/30 dark:text-blue-300 dark:ring-blue-400/30',
  MongoDB: 'from-emerald-500/15 to-emerald-500/5 text-emerald-700 ring-emerald-500/30 dark:text-emerald-300 dark:ring-emerald-400/30',
  Redis: 'from-red-500/15 to-red-500/5 text-red-700 ring-red-500/30 dark:text-red-300 dark:ring-red-400/30',
  Docker: 'from-cyan-500/15 to-cyan-500/5 text-cyan-700 ring-cyan-500/30 dark:text-cyan-300 dark:ring-cyan-400/30',
  Kubernetes: 'from-indigo-500/15 to-indigo-500/5 text-indigo-700 ring-indigo-500/30 dark:text-indigo-300 dark:ring-indigo-400/30',
  AWS: 'from-amber-500/15 to-amber-500/5 text-amber-700 ring-amber-500/30 dark:text-amber-300 dark:ring-amber-400/30',
  GCP: 'from-blue-400/15 to-blue-400/5 text-blue-700 ring-blue-400/30 dark:text-blue-200 dark:ring-blue-300/30',
  Azure: 'from-sky-400/15 to-sky-400/5 text-sky-700 ring-sky-400/30 dark:text-sky-200 dark:ring-sky-300/30',
  Git: 'from-orange-500/15 to-orange-500/5 text-orange-700 ring-orange-500/30 dark:text-orange-300 dark:ring-orange-400/30',
  Linux: 'from-slate-400/15 to-slate-400/5 text-slate-700 ring-slate-400/30 dark:text-slate-200 dark:ring-slate-300/30',
  Monitoring: 'from-rose-500/15 to-rose-500/5 text-rose-700 ring-rose-500/30 dark:text-rose-300 dark:ring-rose-400/30',
};

function Highlighted({ text, query, className }) {
  const parts = highlightText(text, query);
  return (
    <span className={className}>
      {parts.map((part, i) =>
        part.type === 'mark' ? (
          <mark
            key={`${part.value}-${i}`}
            className="rounded-sm bg-brand-400/30 px-0.5 text-inherit dark:bg-brand-400/40"
          >
            {part.value}
          </mark>
        ) : (
          <span key={`${part.value}-${i}`}>{part.value}</span>
        )
      )}
    </span>
  );
}

export default function CommandCard({ command, index = 0, highlightQuery = '' }) {
  const accent =
    CATEGORY_ACCENTS[command.category] ||
    'from-brand-500/15 to-brand-500/5 text-brand-700 ring-brand-500/30 dark:text-brand-300 dark:ring-brand-400/30';

  return (
    <Link
      to={`/commands/${command.id}`}
      style={{ animationDelay: `${Math.min(index * 45, 400)}ms` }}
      className="group relative flex animate-fade-up flex-col overflow-hidden rounded-2xl border border-slate-200 bg-white/80 p-5 shadow-sm backdrop-blur-xl transition-all duration-300 hover:-translate-y-1 hover:border-brand-400/50 hover:shadow-glow dark:border-white/10 dark:bg-white/[0.04] dark:shadow-card dark:hover:border-brand-400/40 dark:hover:bg-white/[0.07]"
    >
      <span className="pointer-events-none absolute -right-16 -top-16 h-40 w-40 rounded-full bg-brand-gradient opacity-0 blur-3xl transition-opacity duration-500 group-hover:opacity-20" />

      <div className="mb-3 flex items-start justify-between gap-2">
        <h3 className="font-mono text-base font-semibold text-slate-900 transition-colors group-hover:text-brand-600 dark:text-white dark:group-hover:text-brand-200">
          <Highlighted text={command.name} query={highlightQuery} />
        </h3>
        <span
          className={`shrink-0 rounded-full bg-gradient-to-br px-2.5 py-0.5 text-[11px] font-medium ring-1 ${accent}`}
        >
          {command.category}
        </span>
      </div>

      <p className="mb-4 line-clamp-2 flex-1 text-sm leading-relaxed text-slate-600 dark:text-slate-400">
        <Highlighted
          text={command.description || 'No description'}
          query={highlightQuery}
        />
      </p>

      {command.tags?.length > 0 && (
        <div className="flex flex-wrap gap-1.5">
          {command.tags.slice(0, 4).map((tag) => (
            <span
              key={tag}
              className="rounded-md border border-slate-200 bg-slate-100 px-2 py-0.5 font-mono text-[11px] text-slate-500 dark:border-white/5 dark:bg-ink-800/60 dark:text-slate-400"
            >
              #{tag}
            </span>
          ))}
        </div>
      )}

      <span className="mt-4 flex items-center gap-1 text-xs font-medium text-brand-600 opacity-0 transition-all duration-300 group-hover:opacity-100 dark:text-brand-300">
        Configure
        <svg className="h-3.5 w-3.5 transition-transform group-hover:translate-x-1" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
          <path d="M5 12h14M12 5l7 7-7 7" />
        </svg>
      </span>
    </Link>
  );
}
