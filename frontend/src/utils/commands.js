export const CATEGORIES = [
  'MySQL',
  'PostgreSQL',
  'MongoDB',
  'Redis',
  'Docker',
  'Kubernetes',
  'AWS',
  'GCP',
  'Azure',
  'Git',
  'Linux',
  'Monitoring',
];

export function substituteTemplate(template, values) {
  if (!template) return '';
  return template.replace(/\{\{(\w+)\}\}/g, (_, key) => {
    const value = values[key];
    return value === undefined || value === null ? `{{${key}}}` : String(value);
  });
}

export function buildDefaultValues(properties = []) {
  return properties.reduce((acc, prop) => {
    if (prop.property_type === 'boolean') {
      acc[prop.property_name] =
        prop.default_value === 'true' || prop.default_value === true;
    } else {
      acc[prop.property_name] = prop.default_value ?? '';
    }
    return acc;
  }, {});
}

export function highlightText(text, query) {
  const source = text ?? '';
  const trimmed = (query || '').trim();
  if (!trimmed || !source) {
    return [{ type: 'text', value: source }];
  }

  const escaped = trimmed.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  const regex = new RegExp(`(${escaped})`, 'gi');
  const parts = source.split(regex);

  return parts.filter(Boolean).map((part) =>
    part.toLowerCase() === trimmed.toLowerCase()
      ? { type: 'mark', value: part }
      : { type: 'text', value: part }
  );
}

export function validatePropertyValues(properties = [], values = {}) {
  const errors = {};

  for (const prop of properties) {
    const name = prop.property_name;
    const raw = values[name];
    const isEmpty =
      prop.property_type === 'boolean'
        ? false
        : raw === undefined || raw === null || String(raw).trim() === '';

    if (prop.is_required && isEmpty) {
      errors[name] = 'This field is required';
      continue;
    }

    if (!isEmpty && prop.validation_pattern) {
      try {
        const pattern = new RegExp(prop.validation_pattern);
        if (!pattern.test(String(raw))) {
          errors[name] = 'Value does not match the required pattern';
        }
      } catch {
        /* ignore invalid patterns from seed data */
      }
    }
  }

  return errors;
}
