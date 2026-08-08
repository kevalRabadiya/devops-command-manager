import { useCallback, useEffect, useState } from 'react';
import categoryService from '../services/categoryService';

function sortByName(categories) {
  return [...categories].sort((a, b) => a.name.localeCompare(b.name));
}

export default function useCategories() {
  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [reloadToken, setReloadToken] = useState(0);

  useEffect(() => {
    let cancelled = false;

    async function load() {
      setLoading(true);
      setError(null);
      try {
        const data = await categoryService.getAll();
        if (!cancelled) setCategories(sortByName(data || []));
      } catch (err) {
        if (!cancelled) {
          setError(err.message);
          setCategories([]);
        }
      } finally {
        if (!cancelled) setLoading(false);
      }
    }

    load();
    return () => {
      cancelled = true;
    };
  }, [reloadToken]);

  const refetch = useCallback(() => setReloadToken((t) => t + 1), []);

  const addCategory = useCallback((category) => {
    setCategories((prev) => sortByName([...prev, category]));
  }, []);

  const replaceCategory = useCallback((category) => {
    setCategories((prev) =>
      sortByName(prev.map((c) => (c.id === category.id ? category : c)))
    );
  }, []);

  const removeCategory = useCallback(async (id) => {
    await categoryService.remove(id);
    setCategories((prev) => prev.filter((c) => c.id !== id));
  }, []);

  return {
    categories,
    loading,
    error,
    refetch,
    addCategory,
    replaceCategory,
    removeCategory,
  };
}
