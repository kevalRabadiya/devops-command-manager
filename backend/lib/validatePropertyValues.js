function isEmptyValue(prop, raw) {
  if (prop.property_type === 'boolean') {
    return raw === undefined || raw === null;
  }
  return raw === undefined || raw === null || String(raw).trim() === '';
}

function validatePropertyValues(properties = [], propertyValues = {}) {
  const errors = {};
  const knownNames = new Set(properties.map((p) => p.property_name));

  for (const key of Object.keys(propertyValues)) {
    if (!knownNames.has(key)) {
      errors[key] = 'Unknown property';
    }
  }

  for (const prop of properties) {
    const name = prop.property_name;
    const raw = propertyValues[name];

    if (prop.property_type === 'boolean') {
      if (raw !== undefined && raw !== null && typeof raw !== 'boolean') {
        errors[name] = 'Must be a boolean';
        continue;
      }
    } else if (raw !== undefined && raw !== null && typeof raw === 'object') {
      errors[name] = 'Must be a scalar value';
      continue;
    }

    const isEmpty = isEmptyValue(prop, raw);

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

  return {
    valid: Object.keys(errors).length === 0,
    errors,
  };
}

module.exports = { validatePropertyValues };
