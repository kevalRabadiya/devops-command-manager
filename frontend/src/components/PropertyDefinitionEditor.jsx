const PROPERTY_TYPES = ['text', 'number', 'boolean', 'password', 'select'];

let nextRowId = 1;

export function makeEmptyPropertyRow() {
  return {
    _key: `prop-${nextRowId++}`,
    property_name: '',
    property_type: 'text',
    placeholder: '',
    description: '',
    default_value: '',
    is_required: false,
    select_options: '',
  };
}

// Drops incomplete rows and reshapes rows into the {property_name, property_type, ...}
// payload the backend/commands schema expects (see backend/validators/commandSchemas.js).
export function serializeProperties(rows) {
  return rows
    .filter((row) => row.property_name.trim())
    .map((row, index) => ({
      property_name: row.property_name.trim(),
      property_type: row.property_type,
      default_value: row.default_value.trim() || undefined,
      is_required: row.is_required,
      placeholder: row.placeholder.trim() || undefined,
      description: row.description.trim() || undefined,
      select_options:
        row.property_type === 'select'
          ? row.select_options
              .split(',')
              .map((opt) => opt.trim())
              .filter(Boolean)
          : undefined,
      display_order: index + 1,
    }));
}

export default function PropertyDefinitionEditor({ rows, onChange }) {
  const updateRow = (key, patch) => {
    onChange(rows.map((row) => (row._key === key ? { ...row, ...patch } : row)));
  };

  const addRow = () => onChange([...rows, makeEmptyPropertyRow()]);
  const removeRow = (key) => onChange(rows.filter((row) => row._key !== key));

  return (
    <div className="space-y-3">
      <div className="flex items-center justify-between">
        <label className="block text-sm font-medium text-slate-700 dark:text-slate-300">
          Command properties <span className="font-normal text-slate-400">(optional)</span>
        </label>
        <button
          type="button"
          onClick={addRow}
          className="text-xs font-semibold text-brand-600 hover:text-brand-700 dark:text-brand-300 dark:hover:text-brand-200"
        >
          + Add property
        </button>
      </div>

      {rows.length === 0 && (
        <p className="text-xs text-slate-500 dark:text-slate-400">
          Define the placeholders used in your example command (e.g. host, port) so
          reviewers know what to fill in.
        </p>
      )}

      {rows.map((row) => (
        <div
          key={row._key}
          className="grid gap-2 rounded-xl border border-slate-200 bg-slate-50 p-3 dark:border-white/10 dark:bg-white/[0.03] sm:grid-cols-12"
        >
          <input
            type="text"
            value={row.property_name}
            onChange={(e) => updateRow(row._key, { property_name: e.target.value })}
            placeholder="name (e.g. host)"
            className="input-base col-span-3 font-mono text-sm"
          />
          <select
            value={row.property_type}
            onChange={(e) => updateRow(row._key, { property_type: e.target.value })}
            className="input-base col-span-2 cursor-pointer text-sm"
          >
            {PROPERTY_TYPES.map((type) => (
              <option key={type} value={type}>
                {type}
              </option>
            ))}
          </select>
          <input
            type="text"
            value={row.placeholder}
            onChange={(e) => updateRow(row._key, { placeholder: e.target.value })}
            placeholder="placeholder"
            className="input-base col-span-2 text-sm"
          />
          <input
            type="text"
            value={
              row.property_type === 'select' ? row.select_options : row.description
            }
            onChange={(e) =>
              updateRow(
                row._key,
                row.property_type === 'select'
                  ? { select_options: e.target.value }
                  : { description: e.target.value }
              )
            }
            placeholder={row.property_type === 'select' ? 'options, comma, separated' : 'description'}
            className="input-base col-span-3 text-sm"
          />
          <label className="col-span-1 flex items-center justify-center gap-1.5 text-xs text-slate-600 dark:text-slate-300">
            <input
              type="checkbox"
              checked={row.is_required}
              onChange={(e) => updateRow(row._key, { is_required: e.target.checked })}
              className="h-4 w-4 cursor-pointer rounded border-slate-300 text-brand-600 focus:ring-brand-500 dark:border-white/20"
            />
            required
          </label>
          <button
            type="button"
            onClick={() => removeRow(row._key)}
            aria-label="Remove property"
            className="col-span-1 flex items-center justify-center rounded-lg text-slate-400 transition-colors hover:bg-red-500/10 hover:text-red-500"
          >
            ✕
          </button>
        </div>
      ))}
    </div>
  );
}
