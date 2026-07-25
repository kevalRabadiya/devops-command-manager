import { useEffect, useMemo, useState } from 'react';
import { Link, useParams } from 'react-router-dom';
import commandService from '../services/commandService';
import PropertyForm from '../components/PropertyForm';
import useClipboard from '../hooks/useClipboard';
import { useApp } from '../context/AppContext';
import {
  buildDefaultValues,
  substituteTemplate,
  validatePropertyValues,
} from '../utils/commands';

export default function CommandPage() {
  const { id } = useParams();
  const { copy } = useClipboard();
  const { showToast } = useApp();
  const [command, setCommand] = useState(null);
  const [values, setValues] = useState({});
  const [errors, setErrors] = useState({});
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [copied, setCopied] = useState(false);

  useEffect(() => {
    let cancelled = false;

    async function load() {
      setLoading(true);
      setError(null);
      try {
        const data = await commandService.getById(id);
        if (cancelled) return;
        setCommand(data);
        setValues(buildDefaultValues(data.properties || []));
        setErrors({});
      } catch (err) {
        if (!cancelled) setError(err.message);
      } finally {
        if (!cancelled) setLoading(false);
      }
    }

    load();
    return () => {
      cancelled = true;
    };
  }, [id]);

  const preview = useMemo(() => {
    if (!command) return '';
    return substituteTemplate(command.command_template, values);
  }, [command, values]);

  const handleValuesChange = (next) => {
    setValues(next);
    if (Object.keys(errors).length > 0) {
      setErrors(validatePropertyValues(command?.properties || [], next));
    }
  };

  const handleCopy = async () => {
    const nextErrors = validatePropertyValues(command.properties || [], values);
    setErrors(nextErrors);
    if (Object.keys(nextErrors).length > 0) {
      showToast('Fix validation errors before copying', 'error');
      return;
    }

    const ok = await copy(preview);
    if (ok) {
      setCopied(true);
      setTimeout(() => setCopied(false), 1500);
    }
  };

  if (loading) {
    return (
      <div className="flex items-center gap-3 text-slate-500 dark:text-slate-400">
        <span className="h-4 w-4 animate-spin rounded-full border-2 border-brand-400 border-t-transparent" />
        Loading command…
      </div>
    );
  }

  if (error) {
    return (
      <div className="animate-scale-in space-y-3 rounded-2xl border border-red-500/30 bg-red-500/10 p-6">
        <p className="text-red-600 dark:text-red-300">{error}</p>
        <Link to="/" className="text-sm text-brand-600 hover:underline dark:text-brand-300">
          ← Back to search
        </Link>
      </div>
    );
  }

  if (!command) return null;

  return (
    <div className="animate-fade-up space-y-8">
      <div>
        <Link
          to="/"
          className="inline-flex items-center gap-1.5 text-sm text-slate-500 transition-colors hover:text-brand-600 dark:text-slate-400 dark:hover:text-brand-300"
        >
          <svg className="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
            <path d="M19 12H5M12 19l-7-7 7-7" />
          </svg>
          Back to search
        </Link>

        <div className="mt-4 flex flex-wrap items-center gap-3">
          <h2 className="font-mono text-2xl font-bold text-slate-900 dark:text-white sm:text-3xl">
            {command.name}
          </h2>
          <span className="rounded-full border border-brand-400/30 bg-brand-500/10 px-3 py-1 text-xs font-medium text-brand-600 dark:text-brand-200">
            {command.category}
          </span>
        </div>
        {command.description && (
          <p className="mt-2 max-w-2xl text-slate-600 dark:text-slate-400">{command.description}</p>
        )}
        {command.tags?.length > 0 && (
          <div className="mt-3 flex flex-wrap gap-1.5">
            {command.tags.map((tag) => (
              <span
                key={tag}
                className="rounded-md border border-slate-200 bg-slate-100 px-2 py-0.5 font-mono text-[11px] text-slate-500 dark:border-white/5 dark:bg-ink-800/60 dark:text-slate-400"
              >
                #{tag}
              </span>
            ))}
          </div>
        )}
      </div>

      <div className="grid gap-6 lg:grid-cols-2">
        <section className="glass-strong rounded-2xl p-4 shadow-sm dark:shadow-card sm:p-6">
          <h3 className="mb-5 flex items-center gap-2 text-sm font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400">
            <svg className="h-4 w-4 text-brand-500 dark:text-brand-300" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
              <path d="M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.39a2 2 0 0 0-.73-2.73l-.15-.08a2 2 0 0 1-1-1.74v-.5a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2z" />
              <circle cx="12" cy="12" r="3" />
            </svg>
            Configure
          </h3>
          <PropertyForm
            properties={command.properties || []}
            values={values}
            onChange={handleValuesChange}
            errors={errors}
          />
        </section>

        <section className="space-y-4">
          <div className="overflow-hidden rounded-2xl border border-ink-700 bg-ink-900 shadow-card ring-1 ring-black/5 dark:border-white/10 dark:ring-white/10">
            <div className="flex items-center justify-between gap-2 border-b border-white/10 px-4 py-3">
              <div className="flex items-center gap-1.5">
                <span className="h-3 w-3 rounded-full bg-red-400/70" />
                <span className="h-3 w-3 rounded-full bg-amber-400/70" />
                <span className="h-3 w-3 rounded-full bg-emerald-400/70" />
                <span className="ml-2 text-xs font-medium text-slate-400">preview</span>
              </div>
              <button
                type="button"
                onClick={handleCopy}
                className="btn-primary px-3 py-1.5 text-xs"
              >
                {copied ? (
                  <>
                    <svg className="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                      <path d="M20 6 9 17l-5-5" />
                    </svg>
                    Copied
                  </>
                ) : (
                  <>
                    <svg className="h-3.5 w-3.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" aria-hidden="true">
                      <rect x="9" y="9" width="13" height="13" rx="2" ry="2" />
                      <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1" />
                    </svg>
                    Copy
                  </>
                )}
              </button>
            </div>
            <pre className="overflow-x-auto whitespace-pre-wrap break-all bg-ink-950/60 p-4 font-mono text-sm leading-relaxed text-emerald-300">
              <span className="select-none text-slate-600">$ </span>
              {preview}
            </pre>
          </div>

          {command.example && (
            <div className="glass rounded-2xl p-5">
              <h3 className="mb-2 text-xs font-semibold uppercase tracking-wider text-slate-500">
                Example
              </h3>
              <pre className="overflow-x-auto whitespace-pre-wrap break-all font-mono text-sm text-slate-600 dark:text-slate-300">
                {command.example}
              </pre>
            </div>
          )}

          {command.syntax_help && (
            <div className="glass rounded-2xl p-5">
              <h3 className="mb-2 text-xs font-semibold uppercase tracking-wider text-slate-500">
                Help
              </h3>
              <p className="text-sm leading-relaxed text-slate-600 dark:text-slate-400">{command.syntax_help}</p>
            </div>
          )}
        </section>
      </div>
    </div>
  );
}
