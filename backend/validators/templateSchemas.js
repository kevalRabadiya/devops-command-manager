const Joi = require('joi');

const createTemplateSchema = Joi.object({
  command_id: Joi.number().integer().positive().required(),
  template_name: Joi.string().max(255).required(),
  property_values: Joi.object().required(),
  description: Joi.string().allow('', null),
});

const listQuerySchema = Joi.object({
  page: Joi.number().integer().min(1).default(1),
  limit: Joi.number().integer().min(1).max(100).default(20),
  command_id: Joi.number().integer().positive(),
});

const idParamSchema = Joi.object({
  id: Joi.number().integer().positive().required(),
});

module.exports = {
  createTemplateSchema,
  listQuerySchema,
  idParamSchema,
};
