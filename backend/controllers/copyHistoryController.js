const Command = require('../models/Command');
const CommandTemplate = require('../models/CommandTemplate');
const CopyHistory = require('../models/CopyHistory');
const Property = require('../models/Property');
const { validatePropertyValues } = require('../lib/validatePropertyValues');

async function getRecent(req, res, next) {
  try {
    const result = await CopyHistory.getRecent(req.query);
    res.json(result);
  } catch (err) {
    next(err);
  }
}

async function create(req, res, next) {
  try {
    const { command_id, copied_command, property_values, command_template_id } =
      req.body;

    const command = await Command.getById(command_id);
    if (!command) {
      return res.status(404).json({ error: 'Command not found' });
    }

    if (command_template_id) {
      const template = await CommandTemplate.getById(command_template_id);
      if (!template) {
        return res.status(404).json({ error: 'Template not found' });
      }
      if (template.command_id !== Number(command_id)) {
        return res.status(400).json({
          error: 'Validation failed',
          details: ['command_template_id does not belong to this command'],
        });
      }
    }

    if (property_values) {
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
    }

    const entry = await CopyHistory.create({
      command_id,
      copied_command,
      property_values,
      command_template_id,
    });

    return res.status(201).json(entry);
  } catch (err) {
    return next(err);
  }
}

module.exports = {
  getRecent,
  create,
};
