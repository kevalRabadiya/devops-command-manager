const Joi = require('joi');

const HEX_COLOR_PATTERN = /^#([0-9A-Fa-f]{3}|[0-9A-Fa-f]{6})$/;

const createCategorySchema = Joi.object({
  name: Joi.string().max(100).required(),
  description: Joi.string().allow('', null),
  icon: Joi.string().max(100).allow('', null),
  color: Joi.string()
    .max(10)
    .pattern(HEX_COLOR_PATTERN)
    .allow('', null)
    .messages({ 'string.pattern.base': 'Color must be a hex value like #3B82F6' }),
});

const updateCategorySchema = Joi.object({
  name: Joi.string().max(100),
  description: Joi.string().allow('', null),
  icon: Joi.string().max(100).allow('', null),
  color: Joi.string()
    .max(10)
    .pattern(HEX_COLOR_PATTERN)
    .allow('', null)
    .messages({ 'string.pattern.base': 'Color must be a hex value like #3B82F6' }),
}).min(1);

const idParamSchema = Joi.object({
  id: Joi.number().integer().positive().required(),
});

module.exports = {
  createCategorySchema,
  updateCategorySchema,
  idParamSchema,
};
