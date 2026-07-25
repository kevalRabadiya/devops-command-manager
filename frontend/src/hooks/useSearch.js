import { useEffect, useRef, useState } from 'react';
import commandService from '../services/commandService';
import { useApp } from '../context/AppContext';

const DEBOUNCE_MS = 300;
const PAGE_SIZE = 20;

export default function useSearch(query, page = 1) {
  const {
    selectedCategory,
    commands,
    loading,
    error,
    setCommands,
    setLoading,
    setError,
  } = useApp();

  const [total, setTotal] = useState(0);
  const requestId = useRef(0);

  useEffect(() => {
    const timer = setTimeout(async () => {
      const currentId = ++requestId.current;
      setLoading(true);
      setError(null);

      try {
        const trimmed = (query || '').trim();
        const category = selectedCategory || undefined;
        let result;

        if (trimmed) {
          result = await commandService.search(trimmed, {
            page,
            limit: PAGE_SIZE,
            category,
          });
        } else {
          result = await commandService.getAll({
            page,
            limit: PAGE_SIZE,
            category,
          });
        }

        if (currentId === requestId.current) {
          setCommands(result.data || []);
          setTotal(result.total ?? 0);
        }
      } catch (err) {
        if (currentId === requestId.current) {
          setError(err.message);
          setCommands([]);
          setTotal(0);
        }
      } finally {
        if (currentId === requestId.current) {
          setLoading(false);
        }
      }
    }, DEBOUNCE_MS);

    return () => clearTimeout(timer);
  }, [
    query,
    page,
    selectedCategory,
    setCommands,
    setLoading,
    setError,
  ]);

  return {
    results: commands,
    total,
    page,
    limit: PAGE_SIZE,
    loading,
    error,
  };
}
