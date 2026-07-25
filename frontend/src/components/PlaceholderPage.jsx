export default function PlaceholderPage({ title, description, icon }) {
  return (
    <div className="animate-scale-in glass relative overflow-hidden rounded-3xl p-12 text-center sm:p-16">
      <span className="pointer-events-none absolute -top-24 left-1/2 h-64 w-64 -translate-x-1/2 animate-float rounded-full bg-brand-500/15 blur-3xl" />
      <div className="relative mx-auto mb-5 flex h-16 w-16 items-center justify-center rounded-2xl border border-slate-200 bg-white text-brand-500 dark:border-white/10 dark:bg-white/[0.04] dark:text-brand-300">
        {icon}
      </div>
      <h2 className="relative text-2xl font-bold text-slate-900 dark:text-white">{title}</h2>
      <p className="relative mx-auto mt-2 max-w-md text-sm text-slate-600 dark:text-slate-400">
        {description}
      </p>
      <span className="relative mt-6 inline-flex items-center gap-2 rounded-full border border-slate-200 bg-white/70 px-4 py-1.5 text-xs font-medium text-slate-500 dark:border-white/10 dark:bg-white/[0.03] dark:text-slate-400">
        <span className="h-1.5 w-1.5 animate-pulse rounded-full bg-amber-400" />
        Coming in a later phase
      </span>
    </div>
  );
}
