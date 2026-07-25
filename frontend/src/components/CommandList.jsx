import CommandCard from './CommandCard';

function SkeletonCard() {
  return (
    <div className="relative overflow-hidden rounded-2xl border border-slate-200 bg-white/70 p-5 dark:border-white/10 dark:bg-white/[0.03]">
      <div className="mb-3 h-5 w-1/2 rounded bg-slate-200 dark:bg-white/10" />
      <div className="mb-2 h-3 w-full rounded bg-slate-100 dark:bg-white/5" />
      <div className="mb-4 h-3 w-3/4 rounded bg-slate-100 dark:bg-white/5" />
      <div className="flex gap-1.5">
        <div className="h-4 w-12 rounded bg-slate-100 dark:bg-white/5" />
        <div className="h-4 w-10 rounded bg-slate-100 dark:bg-white/5" />
      </div>
      <div className="absolute inset-0 -translate-x-full animate-shimmer bg-gradient-to-r from-transparent via-black/5 to-transparent dark:via-white/5" />
    </div>
  );
}

export default function CommandList({
  commands,
  loading,
  error,
  highlightQuery = '',
}) {
  if (loading) {
    return (
      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {Array.from({ length: 6 }).map((_, i) => (
          <SkeletonCard key={i} />
        ))}
      </div>
    );
  }

  if (error) {
    return (
      <div className="animate-scale-in rounded-2xl border border-red-500/30 bg-red-500/10 p-6 text-center text-red-600 dark:text-red-300">
        {error}
      </div>
    );
  }

  if (!commands?.length) {
    return (
      <div className="animate-scale-in glass rounded-2xl p-12 text-center">
        <div className="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-2xl border border-slate-200 bg-slate-100 dark:border-white/10 dark:bg-white/[0.03]">
          <svg className="h-7 w-7 text-slate-400 dark:text-slate-500" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
            <circle cx="11" cy="11" r="8" />
            <path d="m21 21-4.3-4.3" />
          </svg>
        </div>
        <p className="text-slate-700 dark:text-slate-300">No commands found</p>
        <p className="mt-1 text-sm text-slate-500">Try a different search or category.</p>
      </div>
    );
  }

  return (
    <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
      {commands.map((command, index) => (
        <CommandCard
          key={command.id}
          command={command}
          index={index}
          highlightQuery={highlightQuery}
        />
      ))}
    </div>
  );
}
