export default function PropertyForm({
  properties = [],
  values,
  onChange,
  errors = {},
}) {
  if (!properties.length) {
    return (
      <p className="rounded-xl border border-slate-200 bg-slate-50 p-4 text-sm text-slate-500 dark:border-white/10 dark:bg-white/[0.03] dark:text-slate-400">
        This command has no configurable properties.
      </p>
    );
  }

  const handleChange = (name, value) => {
    onChange({ ...values, [name]: value });
  };

  const inputClass = (name) =>
    `input-base font-mono ${
      errors[name]
        ? 'border-red-500/60 ring-2 ring-red-500/20 focus:border-red-500 focus:ring-red-500/30'
        : ''
    }`;

  const errorEl = (name) =>
    errors[name] ? (
      <p className="mt-1.5 text-xs font-medium text-red-600 dark:text-red-300">
        {errors[name]}
      </p>
    ) : null;

  return (
    <div className="space-y-5">
      {properties.map((prop) => {
        const id = `prop-${prop.id || prop.property_name}`;
        const name = prop.property_name;

        const labelEl = (
          <label
            htmlFor={id}
            className="mb-1.5 flex items-center gap-1.5 text-sm font-medium text-slate-700 dark:text-slate-300"
          >
            <span className="font-mono">{name}</span>
            {prop.is_required && (
              <span className="rounded bg-red-500/15 px-1.5 text-[10px] font-semibold uppercase text-red-500 dark:text-red-300">
                required
              </span>
            )}
          </label>
        );

        if (prop.property_type === 'boolean') {
          const checked = Boolean(values[name]);
          return (
            <div key={name}>
              <label
                htmlFor={id}
                className={`flex cursor-pointer items-center justify-between rounded-xl border bg-slate-50 px-4 py-3 transition-colors hover:bg-slate-100 dark:bg-white/[0.03] dark:hover:bg-white/[0.05] ${
                  errors[name]
                    ? 'border-red-500/50'
                    : 'border-slate-200 dark:border-white/10'
                }`}
              >
                <span className="text-sm text-slate-700 dark:text-slate-300">
                  <span className="font-mono">{name}</span>
                  {prop.description ? (
                    <span className="ml-1 text-slate-500">— {prop.description}</span>
                  ) : null}
                </span>
                <span className="relative inline-flex h-6 w-11 shrink-0 items-center">
                  <input
                    id={id}
                    type="checkbox"
                    checked={checked}
                    onChange={(e) => handleChange(name, e.target.checked)}
                    className="peer sr-only"
                    aria-invalid={Boolean(errors[name])}
                  />
                  <span className="h-6 w-11 rounded-full bg-slate-300 transition-colors peer-checked:bg-brand-gradient dark:bg-ink-700" />
                  <span className="absolute left-0.5 h-5 w-5 rounded-full bg-white shadow transition-transform peer-checked:translate-x-5" />
                </span>
              </label>
              {errorEl(name)}
            </div>
          );
        }

        if (prop.property_type === 'select') {
          const options = Array.isArray(prop.select_options)
            ? prop.select_options
            : [];
          return (
            <div key={name}>
              {labelEl}
              <select
                id={id}
                value={values[name] ?? ''}
                onChange={(e) => handleChange(name, e.target.value)}
                className={`${inputClass(name)} cursor-pointer`}
                aria-invalid={Boolean(errors[name])}
              >
                <option value="">Select…</option>
                {options.map((opt) => (
                  <option key={opt} value={opt}>
                    {opt}
                  </option>
                ))}
              </select>
              {prop.description && !errors[name] && (
                <p className="mt-1.5 text-xs text-slate-500">{prop.description}</p>
              )}
              {errorEl(name)}
            </div>
          );
        }

        const inputType =
          prop.property_type === 'password'
            ? 'password'
            : prop.property_type === 'number'
              ? 'number'
              : 'text';

        return (
          <div key={name}>
            {labelEl}
            <input
              id={id}
              type={inputType}
              value={values[name] ?? ''}
              placeholder={prop.placeholder || ''}
              onChange={(e) => handleChange(name, e.target.value)}
              className={inputClass(name)}
              aria-invalid={Boolean(errors[name])}
            />
            {prop.description && !errors[name] && (
              <p className="mt-1.5 text-xs text-slate-500">{prop.description}</p>
            )}
            {errorEl(name)}
          </div>
        );
      })}
    </div>
  );
}
