const express = require('express');
const categoryController = require('../controllers/categoryController');
const { validate } = require('../middleware/validate');
const {
  createCategorySchema,
  updateCategorySchema,
  idParamSchema,
} = require('../validators/categorySchemas');

const router = express.Router();

router.get('/', categoryController.getAll);
router.post(
  '/',
  validate(createCategorySchema, 'body'),
  categoryController.create
);
router.put(
  '/:id',
  validate(idParamSchema, 'params'),
  validate(updateCategorySchema, 'body'),
  categoryController.update
);
router.delete(
  '/:id',
  validate(idParamSchema, 'params'),
  categoryController.delete
);

module.exports = router;
