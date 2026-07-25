const express = require('express');
const commandController = require('../controllers/commandController');
const { validate } = require('../middleware/validate');
const {
  createCommandSchema,
  updateCommandSchema,
  listQuerySchema,
  searchQuerySchema,
  idParamSchema,
} = require('../validators/commandSchemas');

const router = express.Router();

router.get('/', validate(listQuerySchema, 'query'), commandController.getAll);
router.get(
  '/search',
  validate(searchQuerySchema, 'query'),
  commandController.search
);
router.get(
  '/:id',
  validate(idParamSchema, 'params'),
  commandController.getById
);
router.post(
  '/',
  validate(createCommandSchema, 'body'),
  commandController.create
);
router.put(
  '/:id',
  validate(idParamSchema, 'params'),
  validate(updateCommandSchema, 'body'),
  commandController.update
);
router.delete(
  '/:id',
  validate(idParamSchema, 'params'),
  commandController.delete
);

module.exports = router;
