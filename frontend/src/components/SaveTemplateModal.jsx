import { useState } from 'react';

export default function SaveTemplateModal({
  open,
  onClose,
  onSave,
  saving = false,
}) {
  const [templateName, setTemplateName] = useState('');
  const [description, setDescription] = useState('');
  const [error, setError] = useState('');

  if (!open) return null;

  const handleSubmit = async (e) => {
    e.preventDefault();
    const name = templateName.trim();
    if (!name) {
      setError('Template name is required');
      return;
    }
    setError('');
    try {
      await onSave({ template_name: name, description: description.trim() || null });
      setTemplateName('');
      setDescription('');
      onClose();
    } catch (err) {
      setError(err.message);
    }
  };

  const handleClose = () => {
    if (saving) return;
    setError('');
    onClose();
  };

  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center p-4"
      role="dialog"
      aria-modal="true"
      aria-labelledby="save-template-title"
    >
      <button
        type="button"
        className="absolute inset-0 bg-ink-950/60 backdrop-blur-sm"
        aria-label="Close dialog"
        onClick={handleClose}
      />

      <form
        onSubmit={handleSubmit}
        className="relative z-10 w-full max-w-md animate-scale-in rounded-2xl border border-slate-200 bg-white p-6 shadow-xl dark:border-white/10 dark:bg-ink-900"
      >
        <h3
          id="save-template-title"
          className="text-lg font-semibold text-slate-900 dark:text-white"
        >
          Save as template
        </h3>
        <p className="mt-1 text-sm text-slate-500 dark:text-slate-400">
          Store the current property configuration for quick reuse.
        </p>

        <div className="mt-5 space-y-4">
          <div>
            <label
              htmlFor="template-name"
              className="mb-1.5 block text-xs font-semibold uppercase tracking-wider text-slate-500"
            >
              Template name
            </label>
            <input
              id="template-name"
              type="text"
              value={templateName}
              onChange={(e) => setTemplateName(e.target.value)}
              className="input-base"
              placeholder="e.g. Production deploy"
              maxLength={255}
              autoFocus
            />
          </div>

          <div>
            <label
              htmlFor="template-description"
              className="mb-1.5 block text-xs font-semibold uppercase tracking-wider text-slate-500"
            >
              Description (optional)
            </label>
            <textarea
              id="template-description"
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              className="input-base min-h-[80px] resize-y"
              placeholder="Notes about this configuration"
              rows={3}
            />
          </div>

          {error && (
            <p className="text-sm font-medium text-red-600 dark:text-red-300">{error}</p>
          )}
        </div>

        <div className="mt-6 flex justify-end gap-2">
          <button
            type="button"
            onClick={handleClose}
            disabled={saving}
            className="rounded-xl px-4 py-2 text-sm font-medium text-slate-600 transition-colors hover:bg-slate-100 disabled:opacity-50 dark:text-slate-300 dark:hover:bg-white/[0.06]"
          >
            Cancel
          </button>
          <button type="submit" disabled={saving} className="btn-primary px-4 py-2 text-sm">
            {saving ? 'Saving…' : 'Save template'}
          </button>
        </div>
      </form>
    </div>
  );
}
