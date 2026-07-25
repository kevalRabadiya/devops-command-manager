const Joi = require('joi');

const propertyType = Joi.string().valid(
  'text',
  'select',
  'number',
  'boolean',
  'password'
);

const propertySchema = Joi.object({
  property_name: Joi.string().max(100).required(),
  property_type: propertyType.required(),
  default_value: Joi.string().allow('', null),
  is_required: Joi.boolean().default(false),
  placeholder: Joi.string().allow('', null),
  description: Joi.string().max(255).allow('', null),
  select_options: Joi.alternatives()
    .try(Joi.array().items(Joi.string()), Joi.object())
    .allow(null),
  validation_pattern: Joi.string().max(255).allow('', null),
  display_order: Joi.number().integer().allow(null),
});

const createCommandSchema = Joi.object({
  name: Joi.string().max(255).required(),
  description: Joi.string().allow('', null),
  command_template: Joi.string().required(),
  category: Joi.string().max(100).required(),
  tags: Joi.array().items(Joi.string()).default([]),
  example: Joi.string().allow('', null),
  syntax_help: Joi.string().allow('', null),
  properties: Joi.array().items(propertySchema).default([]),
});

const updateCommandSchema = Joi.object({
  name: Joi.string().max(255),
  description: Joi.string().allow('', null),
  command_template: Joi.string(),
  category: Joi.string().max(100),
  tags: Joi.array().items(Joi.string()),
  example: Joi.string().allow('', null),
  syntax_help: Joi.string().allow('', null),
}).min(1);

const listQuerySchema = Joi.object({
  page: Joi.number().integer().min(1).default(1),
  limit: Joi.number().integer().min(1).max(100).default(20),
  category: Joi.string().max(100),
});

const searchQuerySchema = Joi.object({
  q: Joi.string().trim().min(1).required(),
  page: Joi.number().integer().min(1).default(1),
  limit: Joi.number().integer().min(1).max(100).default(20),
  category: Joi.string().max(100),
});

const idParamSchema = Joi.object({
  id: Joi.number().integer().positive().required(),
});

module.exports = {
  createCommandSchema,
  updateCommandSchema,
  listQuerySchema,
  searchQuerySchema,
  idParamSchema,
  propertySchema,
};
