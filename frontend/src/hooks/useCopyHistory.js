import { useCallback, useEffect, useState } from 'react';
import copyHistoryService from '../services/copyHistoryService';

const HISTORY_LIMIT = 20;

export default function useCopyHistory({ autoLoad = true } = {}) {
  const [history, setHistory] = useState([]);
  const [loading, setLoading] = useState(autoLoad);
  const [error, setError] = useState(null);

  const refresh = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const result = await copyHistoryService.list({ limit: HISTORY_LIMIT });
      setHistory(result.data || []);
    } catch (err) {
      setError(err.message);
      setHistory([]);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    if (autoLoad) {
      refresh();
    }
  }, [autoLoad, refresh]);

  const prepend = useCallback((entry) => {
    setHistory((prev) => [entry, ...prev].slice(0, HISTORY_LIMIT));
  }, []);

  return {
    history,
    loading,
    error,
    refresh,
    prepend,
    limit: HISTORY_LIMIT,
  };
}
