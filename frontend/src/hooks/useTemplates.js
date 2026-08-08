import { useCallback, useEffect, useState } from 'react';
import templateService from '../services/templateService';

const PAGE_SIZE = 20;

export default function useTemplates({ command_id, page = 1, search = '' } = {}) {
  const [templates, setTemplates] = useState([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [reloadToken, setReloadToken] = useState(0);

  useEffect(() => {
    let cancelled = false;

    async function load() {
      setLoading(true);
      setError(null);
      try {
        const result = await templateService.list({
          page,
          limit: PAGE_SIZE,
          command_id: command_id || undefined,
        });
        if (cancelled) return;

        let rows = result.data || [];
        const query = search.trim().toLowerCase();
        if (query) {
          rows = rows.filter(
            (t) =>
              t.template_name?.toLowerCase().includes(query) ||
              t.command?.name?.toLowerCase().includes(query) ||
              t.command?.category?.toLowerCase().includes(query)
          );
        }

        setTemplates(rows);
        setTotal(query ? rows.length : (result.total ?? 0));
      } catch (err) {
        if (!cancelled) {
          setError(err.message);
          setTemplates([]);
          setTotal(0);
        }
      } finally {
        if (!cancelled) setLoading(false);
      }
    }

    load();
    return () => {
      cancelled = true;
    };
  }, [command_id, page, search, reloadToken]);

  const refetch = useCallback(() => setReloadToken((t) => t + 1), []);

  const remove = useCallback(async (id) => {
    await templateService.remove(id);
    setTemplates((prev) => prev.filter((t) => t.id !== id));
    setTotal((prev) => Math.max(0, prev - 1));
  }, []);

  const prepend = useCallback((template) => {
    setTemplates((prev) => [template, ...prev]);
    setTotal((prev) => prev + 1);
  }, []);

  return {
    templates,
    total,
    page,
    limit: PAGE_SIZE,
    loading,
    error,
    refetch,
    remove,
    prepend,
  };
}
