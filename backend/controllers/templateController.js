const Command = require('../models/Command');
const CommandTemplate = require('../models/CommandTemplate');
const Property = require('../models/Property');
const { validatePropertyValues } = require('../lib/validatePropertyValues');

async function getAll(req, res, next) {
  try {
    const result = await CommandTemplate.getAll(req.query);
    res.json(result);
  } catch (err) {
    next(err);
  }
}

async function getById(req, res, next) {
  try {
    const template = await CommandTemplate.getById(req.params.id);
    if (!template) {
      return res.status(404).json({ error: 'Template not found' });
    }
    return res.json(template);
  } catch (err) {
    return next(err);
  }
}

async function create(req, res, next) {
  try {
    const { command_id, property_values } = req.body;

    const command = await Command.getById(command_id);
    if (!command) {
      return res.status(404).json({ error: 'Command not found' });
    }

    const properties = await Property.getByCommandId(command_id);
    const validation = validatePropertyValues(properties, property_values);
    if (!validation.valid) {
      return res.status(400).json({
        error: 'Validation failed',
        details: Object.entries(validation.errors).map(
          ([field, message]) => `${field}: ${message}`
        ),
      });
    }

    const template = await CommandTemplate.create(req.body);
    return res.status(201).json(template);
  } catch (err) {
    return next(err);
  }
}

async function remove(req, res, next) {
  try {
    const template = await CommandTemplate.delete(req.params.id);
    if (!template) {
      return res.status(404).json({ error: 'Template not found' });
    }
    return res.json({ message: 'Template deleted', template });
  } catch (err) {
    return next(err);
  }
}

module.exports = {
  getAll,
  getById,
  create,
  delete: remove,
};
