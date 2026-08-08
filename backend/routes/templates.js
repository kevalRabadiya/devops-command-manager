const express = require('express');
const templateController = require('../controllers/templateController');
const { validate } = require('../middleware/validate');
const {
  createTemplateSchema,
  listQuerySchema,
  idParamSchema,
} = require('../validators/templateSchemas');

const router = express.Router();

router.get('/', validate(listQuerySchema, 'query'), templateController.getAll);
router.get(
  '/:id',
  validate(idParamSchema, 'params'),
  templateController.getById
);
router.post(
  '/',
  validate(createTemplateSchema, 'body'),
  templateController.create
);
router.delete(
  '/:id',
  validate(idParamSchema, 'params'),
  templateController.delete
);

module.exports = router;
