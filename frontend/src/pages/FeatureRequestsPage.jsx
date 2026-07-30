import { useEffect, useState } from 'react';
import TicketForm from '../components/TicketForm';
import TicketList from '../components/TicketList';
import Pagination from '../components/Pagination';
import useFeatureRequests from '../hooks/useFeatureRequests';
import { useApp } from '../context/AppContext';

const STATUSES = ['pending', 'planned', 'in_progress', 'completed', 'rejected'];

export default function FeatureRequestsPage() {
  const { showToast } = useApp();
  const [status, setStatus] = useState('');
  const [page, setPage] = useState(1);
  const { requests, total, limit, loading, error, castVote, prepend } =
    useFeatureRequests({ status, page });

  useEffect(() => {
    setPage(1);
  }, [status]);

  const handleVote = async (id, direction) => {
    try {
      await castVote(id, direction);
    } catch (err) {
      showToast(err.message, 'error');
    }
  };

  return (
    <div className="space-y-8">
      <section className="relative overflow-hidden rounded-3xl border border-slate-200 bg-white/60 px-4 py-10 text-center shadow-sm backdrop-blur-xl dark:border-white/10 dark:bg-white/[0.03] dark:shadow-card sm:px-6 sm:py-14">
        <span className="pointer-events-none absolute -left-24 -top-24 h-64 w-64 animate-float rounded-full bg-brand-500/20 blur-3xl" />
        <span
          className="pointer-events-none absolute -bottom-24 -right-24 h-64 w-64 animate-float rounded-full bg-accent-violet/20 blur-3xl"
          style={{ animationDelay: '2s' }}
        />

        <h2 className="mx-auto max-w-2xl text-2xl font-bold leading-tight text-slate-900 dark:text-white sm:text-4xl">
          Request a <span className="gradient-text animate-gradient-pan">new command</span>
        </h2>
        <p className="mx-auto mt-3 max-w-xl text-sm text-slate-600 dark:text-slate-400 sm:text-base">
          Submit new command ideas and vote on what the community wants added next.
        </p>
      </section>

      <TicketForm onCreated={prepend} />

      <div className="flex items-center justify-between gap-3">
        <h3 className="text-sm font-semibold uppercase tracking-wider text-slate-500">Requests</h3>
        <select
          value={status}
          onChange={(e) => setStatus(e.target.value)}
          className="input-base w-auto cursor-pointer py-2 text-sm capitalize"
        >
          <option value="">All statuses</option>
          {STATUSES.map((s) => (
            <option key={s} value={s}>
              {s.replace('_', ' ')}
            </option>
          ))}
        </select>
      </div>

      <TicketList tickets={requests} loading={loading} error={error} onVote={handleVote} />

      {!loading && !error && (
        <Pagination page={page} limit={limit} total={total} onPageChange={setPage} />
      )}
    </div>
  );
}
