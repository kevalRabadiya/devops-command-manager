import TicketCard from './TicketCard';

function SkeletonTicket() {
  return (
    <div className="relative overflow-hidden rounded-2xl border border-slate-200 bg-white/70 p-5 dark:border-white/10 dark:bg-white/[0.03]">
      <div className="mb-3 h-5 w-1/2 rounded bg-slate-200 dark:bg-white/10" />
      <div className="mb-2 h-3 w-full rounded bg-slate-100 dark:bg-white/5" />
      <div className="h-3 w-3/4 rounded bg-slate-100 dark:bg-white/5" />
      <div className="absolute inset-0 -translate-x-full animate-shimmer bg-gradient-to-r from-transparent via-black/5 to-transparent dark:via-white/5" />
    </div>
  );
}

export default function TicketList({ tickets, loading, error, onVote }) {
  if (loading) {
    return (
      <div className="space-y-4">
        {Array.from({ length: 4 }).map((_, i) => (
          <SkeletonTicket key={i} />
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

  if (!tickets?.length) {
    return (
      <div className="animate-scale-in glass rounded-2xl p-12 text-center">
        <div className="mx-auto mb-4 flex h-14 w-14 items-center justify-center rounded-2xl border border-slate-200 bg-slate-100 dark:border-white/10 dark:bg-white/[0.03]">
          <svg className="h-7 w-7 text-slate-400 dark:text-slate-500" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
            <path d="M9 18h6M10 22h4M15.09 14c.18-.98.65-1.74 1.41-2.5A4.65 4.65 0 0 0 18 8 6 6 0 0 0 6 8c0 1 .23 2.23 1.5 3.5.76.76 1.23 1.52 1.41 2.5" />
          </svg>
        </div>
        <p className="text-slate-700 dark:text-slate-300">No feature requests yet</p>
        <p className="mt-1 text-sm text-slate-500">Be the first to suggest a new command.</p>
      </div>
    );
  }

  return (
    <div className="space-y-4">
      {tickets.map((ticket) => (
        <TicketCard key={ticket.id} ticket={ticket} onVote={onVote} />
      ))}
    </div>
  );
}
