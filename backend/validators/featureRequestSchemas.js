const Joi = require('joi');

const PRIORITIES = ['low', 'medium', 'high'];
const STATUSES = ['pending', 'planned', 'in_progress', 'completed', 'rejected'];

const createFeatureRequestSchema = Joi.object({
  title: Joi.string().max(255).required(),
  description: Joi.string().required(),
  command_example: Joi.string().allow('', null),
  category: Joi.string().max(100).allow('', null),
  priority: Joi.string()
    .valid(...PRIORITIES)
    .default('medium'),
  requested_by: Joi.string().max(100).default('anonymous'),
});

const updateFeatureRequestSchema = Joi.object({
  title: Joi.string().max(255),
  description: Joi.string(),
  command_example: Joi.string().allow('', null),
  category: Joi.string().max(100).allow('', null),
  priority: Joi.string().valid(...PRIORITIES),
  status: Joi.string().valid(...STATUSES),
  notes: Joi.string().allow('', null),
}).min(1);

const listQuerySchema = Joi.object({
  page: Joi.number().integer().min(1).default(1),
  limit: Joi.number().integer().min(1).max(100).default(20),
  status: Joi.string().valid(...STATUSES),
  category: Joi.string().max(100),
});

const voteSchema = Joi.object({
  direction: Joi.string().valid('up', 'down').default('up'),
});

const idParamSchema = Joi.object({
  id: Joi.number().integer().positive().required(),
});

module.exports = {
  createFeatureRequestSchema,
  updateFeatureRequestSchema,
  listQuerySchema,
  voteSchema,
  idParamSchema,
  PRIORITIES,
  STATUSES,
};
