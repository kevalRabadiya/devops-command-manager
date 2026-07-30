import { useCallback, useEffect, useState } from 'react';
import featureRequestService from '../services/featureRequestService';

const PAGE_SIZE = 12;

export default function useFeatureRequests({ status, category, page = 1 } = {}) {
  const [requests, setRequests] = useState([]);
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
        const result = await featureRequestService.getAll({
          page,
          limit: PAGE_SIZE,
          status: status || undefined,
          category: category || undefined,
        });
        if (cancelled) return;
        setRequests(result.data || []);
        setTotal(result.total ?? 0);
      } catch (err) {
        if (!cancelled) {
          setError(err.message);
          setRequests([]);
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
  }, [status, category, page, reloadToken]);

  const refetch = useCallback(() => setReloadToken((t) => t + 1), []);

  const castVote = useCallback(async (id, direction) => {
    const updated = await featureRequestService.vote(id, direction);
    setRequests((prev) => prev.map((r) => (r.id === updated.id ? updated : r)));
    return updated;
  }, []);

  const prepend = useCallback((request) => {
    setRequests((prev) => [request, ...prev]);
    setTotal((prev) => prev + 1);
  }, []);

  return {
    requests,
    total,
    page,
    limit: PAGE_SIZE,
    loading,
    error,
    refetch,
    castVote,
    prepend,
  };
}
