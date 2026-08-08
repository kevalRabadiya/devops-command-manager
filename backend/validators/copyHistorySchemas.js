const Joi = require('joi');

const createCopyHistorySchema = Joi.object({
  command_id: Joi.number().integer().positive().required(),
  copied_command: Joi.string().trim().min(1).required(),
  property_values: Joi.object().allow(null),
  command_template_id: Joi.number().integer().positive().allow(null),
});

const listQuerySchema = Joi.object({
  limit: Joi.number().integer().min(1).max(20).default(20),
});

module.exports = {
  createCopyHistorySchema,
  listQuerySchema,
};
