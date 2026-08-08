import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import TemplateList from '../components/TemplateList';
import CopyHistoryList from '../components/CopyHistoryList';
import Pagination from '../components/Pagination';
import useTemplates from '../hooks/useTemplates';
import useClipboard from '../hooks/useClipboard';
import { useApp } from '../context/AppContext';

export default function TemplatesPage() {
  const navigate = useNavigate();
  const { copy } = useClipboard();
  const { showToast, copyHistory, historyLoading, recordCopy } = useApp();
  const [search, setSearch] = useState('');
  const [page, setPage] = useState(1);
  const [deletingId, setDeletingId] = useState(null);
  const [copyingId, setCopyingId] = useState(null);

  const { templates, total, limit, loading, error, remove } = useTemplates({
    page,
    search,
  });

  const handleLoad = (template) => {
    navigate(`/commands/${template.command_id}`, {
      state: { propertyValues: template.property_values },
    });
  };

  const handleDelete = async (template) => {
    if (!window.confirm(`Delete template "${template.template_name}"?`)) return;

    setDeletingId(template.id);
    try {
      await remove(template.id);
      showToast('Template deleted', 'success');
    } catch (err) {
      showToast(err.message, 'error');
    } finally {
      setDeletingId(null);
    }
  };

  const handleRecopy = async (entry) => {
    setCopyingId(entry.id);
    try {
      const ok = await copy(entry.copied_command);
      if (ok) {
        await recordCopy({
          command_id: entry.command_id,
          copied_command: entry.copied_command,
          property_values: entry.property_values ?? undefined,
          command_template_id: entry.command_template_id ?? undefined,
        });
      }
    } catch (err) {
      showToast(err.message, 'error');
    } finally {
      setCopyingId(null);
    }
  };

  const handleOpen = (entry) => {
    navigate(`/commands/${entry.command_id}`, {
      state: entry.property_values ? { propertyValues: entry.property_values } : undefined,
    });
  };

  return (
    <div className="space-y-10">
      <section className="relative overflow-hidden rounded-3xl border border-slate-200 bg-white/60 px-4 py-10 text-center shadow-sm backdrop-blur-xl dark:border-white/10 dark:bg-white/[0.03] dark:shadow-card sm:px-6 sm:py-14">
        <span className="pointer-events-none absolute -left-24 -top-24 h-64 w-64 animate-float rounded-full bg-brand-500/20 blur-3xl" />
        <span
          className="pointer-events-none absolute -bottom-24 -right-24 h-64 w-64 animate-float rounded-full bg-accent-violet/20 blur-3xl"
          style={{ animationDelay: '2s' }}
        />

        <h2 className="mx-auto max-w-2xl text-2xl font-bold leading-tight text-slate-900 dark:text-white sm:text-4xl">
          Saved <span className="gradient-text animate-gradient-pan">templates</span> & history
        </h2>
        <p className="mx-auto mt-3 max-w-xl text-sm text-slate-600 dark:text-slate-400 sm:text-base">
          Reuse property configurations and quickly copy commands you have used before.
        </p>
      </section>

      <section className="space-y-4">
        <div className="flex flex-wrap items-center justify-between gap-3">
          <h3 className="text-sm font-semibold uppercase tracking-wider text-slate-500">
            Saved Templates
          </h3>
          <input
            type="search"
            value={search}
            onChange={(e) => {
              setSearch(e.target.value);
              setPage(1);
            }}
            placeholder="Filter by name or command…"
            className="input-base w-full max-w-xs py-2 text-sm"
          />
        </div>

        <TemplateList
          templates={templates}
          loading={loading}
          error={error}
          onLoad={handleLoad}
          onDelete={handleDelete}
          deletingId={deletingId}
        />

        {!loading && !error && total > limit && (
          <Pagination page={page} limit={limit} total={total} onPageChange={setPage} />
        )}
      </section>

      <section className="space-y-4">
        <h3 className="text-sm font-semibold uppercase tracking-wider text-slate-500">
          Recent Copies
        </h3>
        <CopyHistoryList
          history={copyHistory}
          loading={historyLoading}
          onRecopy={handleRecopy}
          onOpen={handleOpen}
          copyingId={copyingId}
        />
      </section>
    </div>
  );
}
