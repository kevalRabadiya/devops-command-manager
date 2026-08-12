import { useState } from 'react';

const STATUS_STYLES = {
  pending: 'bg-amber-500/15 text-amber-700 ring-amber-500/30 dark:text-amber-300 dark:ring-amber-400/30',
  approved: 'bg-emerald-500/15 text-emerald-700 ring-emerald-500/30 dark:text-emerald-300 dark:ring-emerald-400/30',
  planned: 'bg-sky-500/15 text-sky-700 ring-sky-500/30 dark:text-sky-300 dark:ring-sky-400/30',
  in_progress: 'bg-indigo-500/15 text-indigo-700 ring-indigo-500/30 dark:text-indigo-300 dark:ring-indigo-400/30',
  completed: 'bg-emerald-500/15 text-emerald-700 ring-emerald-500/30 dark:text-emerald-300 dark:ring-emerald-400/30',
  rejected: 'bg-rose-500/15 text-rose-700 ring-rose-500/30 dark:text-rose-300 dark:ring-rose-400/30',
};

const PRIORITY_STYLES = {
  low: 'text-slate-500 dark:text-slate-400',
  medium: 'text-amber-600 dark:text-amber-300',
  high: 'text-rose-600 dark:text-rose-300',
  highest: 'text-rose-700 dark:text-rose-200',
};

function VoteButton({ direction, count, onVote, disabled }) {
  const isUp = direction === 'up';
  return (
    <button
      type="button"
      onClick={() => onVote(direction)}
      disabled={disabled}
      aria-label={isUp ? 'Upvote' : 'Downvote'}
      className="flex flex-col items-center gap-0.5 rounded-lg px-2 py-1.5 text-slate-500 transition-colors hover:bg-slate-100 hover:text-brand-600 disabled:cursor-not-allowed disabled:opacity-50 dark:text-slate-400 dark:hover:bg-white/[0.06] dark:hover:text-brand-300"
    >
      <svg
        className="h-4 w-4"
        viewBox="0 0 24 24"
        fill="none"
        stroke="currentColor"
        strokeWidth="2.5"
        strokeLinecap="round"
        strokeLinejoin="round"
        aria-hidden="true"
        style={{ transform: isUp ? undefined : 'rotate(180deg)' }}
      >
        <path d="M12 19V5M5 12l7-7 7 7" />
      </svg>
      <span className="text-xs font-semibold">{count}</span>
    </button>
  );
}

export default function TicketCard({ ticket, onVote }) {
  const [voting, setVoting] = useState(false);

  const handleVote = async (direction) => {
    setVoting(true);
    try {
      await onVote(ticket.id, direction);
    } finally {
      setVoting(false);
    }
  };

  return (
    <div className="animate-fade-up flex gap-4 rounded-2xl border border-slate-200 bg-white/80 p-5 shadow-sm backdrop-blur-xl dark:border-white/10 dark:bg-white/[0.04] dark:shadow-card">
      <div className="flex shrink-0 flex-col items-center gap-1 border-r border-slate-200 pr-4 dark:border-white/10">
        <VoteButton direction="up" count={ticket.votes_up} onVote={handleVote} disabled={voting} />
        <VoteButton direction="down" count={ticket.votes_down} onVote={handleVote} disabled={voting} />
      </div>

      <div className="min-w-0 flex-1">
        <div className="mb-2 flex flex-wrap items-start justify-between gap-2">
          <h3 className="text-base font-semibold text-slate-900 dark:text-white">{ticket.title}</h3>
          <span
            className={`shrink-0 rounded-full px-2.5 py-0.5 text-[11px] font-medium capitalize ring-1 ${
              STATUS_STYLES[ticket.status] || STATUS_STYLES.pending
            }`}
          >
            {ticket.status?.replace('_', ' ')}
          </span>
        </div>

        <p className="mb-3 text-sm leading-relaxed text-slate-600 dark:text-slate-400">{ticket.description}</p>

        {ticket.command_example && (
          <pre className="mb-3 overflow-x-auto rounded-lg bg-ink-950/90 p-3 font-mono text-xs text-emerald-300">
            {ticket.command_example}
          </pre>
        )}

        {Array.isArray(ticket.properties) && ticket.properties.length > 0 && (
          <div className="mb-3 flex flex-wrap gap-1.5">
            {ticket.properties.map((prop) => (
              <span
                key={prop.property_name}
                title={prop.description || undefined}
                className="rounded-md border border-slate-200 bg-slate-50 px-2 py-0.5 font-mono text-[11px] text-slate-600 dark:border-white/10 dark:bg-white/[0.03] dark:text-slate-300"
              >
                {prop.property_name}
                {prop.is_required && <span className="text-red-500">*</span>}
                <span className="text-slate-400"> ({prop.property_type})</span>
              </span>
            ))}
          </div>
        )}

        {ticket.notes && (
          <p className="mb-3 text-xs italic text-slate-500 dark:text-slate-400">{ticket.notes}</p>
        )}

        <div className="flex flex-wrap items-center gap-3 text-xs text-slate-500 dark:text-slate-400">
          {ticket.category && (
            <span className="rounded-md border border-slate-200 bg-slate-100 px-2 py-0.5 dark:border-white/5 dark:bg-ink-800/60">
              {ticket.category}
            </span>
          )}
          <span className={`font-medium capitalize ${PRIORITY_STYLES[ticket.priority] || PRIORITY_STYLES.medium}`}>
            {ticket.priority} priority
          </span>
          <span>by {ticket.requested_by || 'anonymous'}</span>
        </div>
      </div>
    </div>
  );
}
