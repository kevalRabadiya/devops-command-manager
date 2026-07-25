import { useCallback } from 'react';
import { useApp } from '../context/AppContext';

export default function useClipboard() {
  const { showToast } = useApp();

  const copy = useCallback(
    async (text) => {
      if (!text) {
        showToast('Nothing to copy', 'error');
        return false;
      }

      try {
        await navigator.clipboard.writeText(text);
        showToast('Copied to clipboard!', 'success');
        return true;
      } catch {
        showToast('Failed to copy', 'error');
        return false;
      }
    },
    [showToast]
  );

  return { copy };
}
