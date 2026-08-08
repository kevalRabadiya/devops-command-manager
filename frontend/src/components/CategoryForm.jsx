import { useState } from 'react';
import categoryService from '../services/categoryService';
import { useApp } from '../context/AppContext';
import CategoryIcon, { CATEGORY_ICON_KEYS } from './CategoryIcon';

const DEFAULT_COLOR = '#6366F1';

function buildInitialForm(category) {
  return {
    name: category?.name || '',
    description: category?.description || '',
    icon: category?.icon || CATEGORY_ICON_KEYS[0],
    color: category?.color || DEFAULT_COLOR,
  };
}

export default function CategoryForm({ category = null, onSaved, onCancel }) {
  const { showToast } = useApp();
  const isEditing = Boolean(category);
  const [form, setForm] = useState(() => buildInitialForm(category));
  const [errors, setErrors] = useState({});
  const [submitting, setSubmitting] = useState(false);

  const handleChange = (field) => (e) => {
    setForm((prev) => ({ ...prev, [field]: e.target.value }));
  };

  const validate = () => {
    const next = {};
    if (!form.name.trim()) next.name = 'Name is required';
    return next;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const nextErrors = validate();
    setErrors(nextErrors);
    if (Object.keys(nextErrors).length > 0) return;

    setSubmitting(true);
    try {
      const payload = {
        name: form.name.trim(),
        description: form.description.trim() || undefined,
        icon: form.icon || undefined,
        color: form.color || undefined,
      };

      const saved = isEditing
        ? await categoryService.update(category.id, payload)
        : await categoryService.create(payload);

      onSaved?.(saved);
      showToast(isEditing ? 'Category updated' : 'Category added', 'success');
      if (!isEditing) {
        setForm(buildInitialForm(null));
        setErrors({});
      }
    } catch (err) {
      showToast(err.message, 'error');
    } finally {
      setSubmitting(false);
    }
  };

  const inputClass = (field) =>
    `input-base ${errors[field] ? 'border-red-500/60 ring-2 ring-red-500/20 focus:border-red-500 focus:ring-red-500/30' : ''}`;

  return (
    <form
      onSubmit={handleSubmit}
      className={
        isEditing
          ? 'space-y-4'
          : 'glass-strong space-y-4 rounded-2xl p-4 shadow-sm dark:shadow-card sm:p-6'
      }
    >
      <div className="grid gap-4 sm:grid-cols-[1fr_auto]">
        <div>
          <label
            htmlFor={`category-name-${category?.id || 'new'}`}
            className="mb-1.5 block text-sm font-medium text-slate-700 dark:text-slate-300"
          >
            Name
          </label>
          <input
            id={`category-name-${category?.id || 'new'}`}
            type="text"
            value={form.name}
            onChange={handleChange('name')}
            placeholder="e.g. Terraform"
            className={inputClass('name')}
          />
          {errors.name && (
            <p className="mt-1.5 text-xs font-medium text-red-600 dark:text-red-300">
              {errors.name}
            </p>
          )}
        </div>

        <div>
          <label
            htmlFor={`category-color-${category?.id || 'new'}`}
            className="mb-1.5 block text-sm font-medium text-slate-700 dark:text-slate-300"
          >
            Color
          </label>
          <div className="flex items-center gap-2">
            <input
              id={`category-color-${category?.id || 'new'}`}
              type="color"
              value={form.color}
              onChange={handleChange('color')}
              className="h-[42px] w-12 cursor-pointer rounded-lg border border-slate-200 bg-transparent p-1 dark:border-white/10"
            />
            <input
              type="text"
              value={form.color}
              onChange={handleChange('color')}
              placeholder="#6366F1"
              className="input-base w-28 font-mono text-xs"
            />
          </div>
        </div>
      </div>

      <div>
        <label
          htmlFor={`category-description-${category?.id || 'new'}`}
          className="mb-1.5 block text-sm font-medium text-slate-700 dark:text-slate-300"
        >
          Description <span className="font-normal text-slate-400">(optional)</span>
        </label>
        <textarea
          id={`category-description-${category?.id || 'new'}`}
          rows={2}
          value={form.description}
          onChange={handleChange('description')}
          placeholder="What kind of commands live here?"
          className="input-base"
        />
      </div>

      <div>
        <span className="mb-1.5 block text-sm font-medium text-slate-700 dark:text-slate-300">
          Icon
        </span>
        <div className="flex flex-wrap gap-2">
          {CATEGORY_ICON_KEYS.map((key) => (
            <button
              key={key}
              type="button"
              onClick={() => setForm((prev) => ({ ...prev, icon: key }))}
              aria-label={key}
              aria-pressed={form.icon === key}
              className={`flex h-9 w-9 items-center justify-center rounded-lg border transition-colors ${
                form.icon === key
                  ? 'border-brand-400 bg-brand-500/15 text-brand-600 dark:border-brand-400/60 dark:text-brand-300'
                  : 'border-slate-200 text-slate-500 hover:border-brand-300 hover:text-brand-500 dark:border-white/10 dark:text-slate-400 dark:hover:border-brand-400/40'
              }`}
            >
              <CategoryIcon icon={key} className="h-4 w-4" />
            </button>
          ))}
        </div>
      </div>

      <div className="flex items-center gap-2">
        <button type="submit" disabled={submitting} className="btn-primary w-full sm:w-auto">
          {submitting ? 'Saving…' : isEditing ? 'Save changes' : 'Add category'}
        </button>
        {isEditing && (
          <button
            type="button"
            onClick={onCancel}
            className="rounded-xl border border-slate-200 px-4 py-2 text-sm font-medium text-slate-600 transition-colors hover:bg-slate-50 dark:border-white/10 dark:text-slate-300 dark:hover:bg-white/[0.06]"
          >
            Cancel
          </button>
        )}
      </div>
    </form>
  );
}
