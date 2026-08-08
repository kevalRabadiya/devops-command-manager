import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useReducer,
  useState,
} from 'react';
import copyHistoryService from '../services/copyHistoryService';

const AppContext = createContext(null);

function getInitialTheme() {
  if (typeof window === 'undefined') return 'dark';
  try {
    const stored = localStorage.getItem('theme');
    if (stored === 'light' || stored === 'dark') return stored;
    return window.matchMedia('(prefers-color-scheme: dark)').matches
      ? 'dark'
      : 'light';
  } catch {
    return 'dark';
  }
}

const initialState = {
  searchQuery: '',
  selectedCategory: '',
  commands: [],
  loading: false,
  error: null,
  toasts: [],
  copyHistory: [],
  historyLoading: false,
};

function reducer(state, action) {
  switch (action.type) {
    case 'SET_SEARCH_QUERY':
      return { ...state, searchQuery: action.payload };
    case 'SET_CATEGORY':
      return { ...state, selectedCategory: action.payload };
    case 'SET_COMMANDS':
      return { ...state, commands: action.payload };
    case 'SET_LOADING':
      return { ...state, loading: action.payload };
    case 'SET_ERROR':
      return { ...state, error: action.payload };
    case 'SHOW_TOAST':
      return { ...state, toasts: [...state.toasts, action.payload] };
    case 'DISMISS_TOAST':
      return {
        ...state,
        toasts: state.toasts.filter((t) => t.id !== action.payload),
      };
    case 'SET_COPY_HISTORY':
      return { ...state, copyHistory: action.payload };
    case 'SET_HISTORY_LOADING':
      return { ...state, historyLoading: action.payload };
    case 'PREPEND_COPY_HISTORY':
      return {
        ...state,
        copyHistory: [action.payload, ...state.copyHistory].slice(0, 20),
      };
    default:
      return state;
  }
}

export function AppProvider({ children }) {
  const [state, dispatch] = useReducer(reducer, initialState);
  const [theme, setTheme] = useState(getInitialTheme);

  useEffect(() => {
    const root = document.documentElement;
    root.classList.toggle('dark', theme === 'dark');
    try {
      localStorage.setItem('theme', theme);
    } catch {
      /* ignore persistence errors */
    }
  }, [theme]);

  const toggleTheme = useCallback(() => {
    setTheme((prev) => (prev === 'dark' ? 'light' : 'dark'));
  }, []);

  const setSearchQuery = useCallback((query) => {
    dispatch({ type: 'SET_SEARCH_QUERY', payload: query });
  }, []);

  const setSelectedCategory = useCallback((category) => {
    dispatch({ type: 'SET_CATEGORY', payload: category });
  }, []);

  const setCommands = useCallback((commands) => {
    dispatch({ type: 'SET_COMMANDS', payload: commands });
  }, []);

  const setLoading = useCallback((loading) => {
    dispatch({ type: 'SET_LOADING', payload: loading });
  }, []);

  const setError = useCallback((error) => {
    dispatch({ type: 'SET_ERROR', payload: error });
  }, []);

  const showToast = useCallback((message, type = 'success') => {
    const id = `${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
    dispatch({ type: 'SHOW_TOAST', payload: { id, message, type } });
    setTimeout(() => {
      dispatch({ type: 'DISMISS_TOAST', payload: id });
    }, 3000);
  }, []);

  const dismissToast = useCallback((id) => {
    dispatch({ type: 'DISMISS_TOAST', payload: id });
  }, []);

  const refreshCopyHistory = useCallback(async () => {
    dispatch({ type: 'SET_HISTORY_LOADING', payload: true });
    try {
      const result = await copyHistoryService.list({ limit: 20 });
      dispatch({ type: 'SET_COPY_HISTORY', payload: result.data || [] });
    } catch {
      dispatch({ type: 'SET_COPY_HISTORY', payload: [] });
    } finally {
      dispatch({ type: 'SET_HISTORY_LOADING', payload: false });
    }
  }, []);

  const recordCopy = useCallback(async (payload) => {
    const entry = await copyHistoryService.create(payload);
    dispatch({ type: 'PREPEND_COPY_HISTORY', payload: entry });
    return entry;
  }, []);

  useEffect(() => {
    refreshCopyHistory();
  }, [refreshCopyHistory]);

  const value = useMemo(
    () => ({
      ...state,
      theme,
      toggleTheme,
      setSearchQuery,
      setSelectedCategory,
      setCommands,
      setLoading,
      setError,
      showToast,
      dismissToast,
      refreshCopyHistory,
      recordCopy,
    }),
    [
      state,
      theme,
      toggleTheme,
      setSearchQuery,
      setSelectedCategory,
      setCommands,
      setLoading,
      setError,
      showToast,
      dismissToast,
      refreshCopyHistory,
      recordCopy,
    ]
  );

  return <AppContext.Provider value={value}>{children}</AppContext.Provider>;
}

export function useApp() {
  const ctx = useContext(AppContext);
  if (!ctx) {
    throw new Error('useApp must be used within AppProvider');
  }
  return ctx;
}
