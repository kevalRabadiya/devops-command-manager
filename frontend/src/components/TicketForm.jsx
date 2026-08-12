import { useState } from 'react';
import useCategories from '../hooks/useCategories';
import featureRequestService from '../services/featureRequestService';
import { useApp } from '../context/AppContext';
import PropertyDefinitionEditor, {
  serializeProperties,
} from './PropertyDefinitionEditor';

const PRIORITIES = ['low', 'medium', 'high', 'highest'];

const initialForm = {
  title: '',
  description: '',
  command_example: '',
  category: '',
  priority: 'medium',
  requested_by: '',
};

export default function TicketForm({ onCreated }) {
  const { showToast } = useApp();
  const { categories } = useCategories();
  const [form, setForm] = useState(initialForm);
  const [propertyRows, setPropertyRows] = useState([]);
  const [errors, setErrors] = useState({});
  const [submitting, setSubmitting] = useState(false);

  const handleChange = (field) => (e) => {
    setForm((prev) => ({ ...prev, [field]: e.target.value }));
  };

  const validate = () => {
    const next = {};
    if (!form.title.trim()) next.title = 'Title is required';
    if (!form.description.trim()) next.description = 'Description is required';
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
        title: form.title.trim(),
        description: form.description.trim(),
        command_example: form.command_example.trim() || undefined,
        category: form.category || undefined,
        priority: form.priority,
        requested_by: form.requested_by.trim() || undefined,
        properties: serializeProperties(propertyRows),
      };
      const created = await featureRequestService.create(payload);
      onCreated?.(created);
      setForm(initialForm);
      setPropertyRows([]);
      setErrors({});
      showToast('Feature request submitted!', 'success');
    } catch (err) {
      showToast(err.message, 'error');
    } finally {
      setSubmitting(false);
    }
  };

  const inputClass = (field) =>
    `input-base ${errors[field] ? 'border-red-500/60 ring-2 ring-red-500/20 focus:border-red-500 focus:ring-red-500/30' : ''}`;

  return (
    <form onSubmit={handleSubmit} className="glass-strong space-y-4 rounded-2xl p-4 shadow-sm dark:shadow-card sm:p-6">
      <div>
        <label htmlFor="ticket-title" className="mb-1.5 block text-sm font-medium text-slate-700 dark:text-slate-300">
          Title
        </label>
        <input
          id="ticket-title"
          type="text"
          value={form.title}
          onChange={handleChange('title')}
          placeholder="e.g. Add a Terraform apply command"
          className={inputClass('title')}
        />
        {errors.title && (
          <p className="mt-1.5 text-xs font-medium text-red-600 dark:text-red-300">{errors.title}</p>
        )}
      </div>

      <div>
        <label htmlFor="ticket-description" className="mb-1.5 block text-sm font-medium text-slate-700 dark:text-slate-300">
          Description
        </label>
        <textarea
          id="ticket-description"
          rows={3}
          value={form.description}
          onChange={handleChange('description')}
          placeholder="What should this command do, and why do you need it?"
          className={inputClass('description')}
        />
        {errors.description && (
          <p className="mt-1.5 text-xs font-medium text-red-600 dark:text-red-300">{errors.description}</p>
        )}
      </div>

      <div>
        <label htmlFor="ticket-example" className="mb-1.5 block text-sm font-medium text-slate-700 dark:text-slate-300">
          Example command <span className="font-normal text-slate-400">(optional)</span>
        </label>
        <textarea
          id="ticket-example"
          rows={2}
          value={form.command_example}
          onChange={handleChange('command_example')}
          placeholder="terraform apply -var-file={{vars_file}}"
          className={`${inputClass('command_example')} font-mono`}
        />
      </div>

      <PropertyDefinitionEditor rows={propertyRows} onChange={setPropertyRows} />

      <div className="grid gap-4 sm:grid-cols-3">
        <div>
          <label htmlFor="ticket-category" className="mb-1.5 block text-sm font-medium text-slate-700 dark:text-slate-300">
            Category
          </label>
          <select
            id="ticket-category"
            value={form.category}
            onChange={handleChange('category')}
            className="input-base cursor-pointer"
          >
            <option value="">None</option>
            {categories.map((c) => (
              <option key={c.id} value={c.name}>
                {c.name}
              </option>
            ))}
          </select>
        </div>

        <div>
          <label htmlFor="ticket-priority" className="mb-1.5 block text-sm font-medium text-slate-700 dark:text-slate-300">
            Priority
          </label>
          <select
            id="ticket-priority"
            value={form.priority}
            onChange={handleChange('priority')}
            className="input-base cursor-pointer capitalize"
          >
            {PRIORITIES.map((p) => (
              <option key={p} value={p}>
                {p}
              </option>
            ))}
          </select>
          {form.priority === 'highest' && (
            <p className="mt-1.5 text-xs font-medium text-rose-600 dark:text-rose-300">
              Highest priority requests are auto-approved and added to the commands list.
            </p>
          )}
        </div>

        <div>
          <label htmlFor="ticket-requester" className="mb-1.5 block text-sm font-medium text-slate-700 dark:text-slate-300">
            Your name <span className="font-normal text-slate-400">(optional)</span>
          </label>
          <input
            id="ticket-requester"
            type="text"
            value={form.requested_by}
            onChange={handleChange('requested_by')}
            placeholder="anonymous"
            className="input-base"
          />
        </div>
      </div>

      <button type="submit" disabled={submitting} className="btn-primary w-full sm:w-auto">
        {submitting ? 'Submitting…' : 'Submit request'}
      </button>
    </form>
  );
}
