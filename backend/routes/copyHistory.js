const express = require('express');
const copyHistoryController = require('../controllers/copyHistoryController');
const { validate } = require('../middleware/validate');
const {
  createCopyHistorySchema,
  listQuerySchema,
} = require('../validators/copyHistorySchemas');

const router = express.Router();

router.get(
  '/',
  validate(listQuerySchema, 'query'),
  copyHistoryController.getRecent
);
router.post(
  '/',
  validate(createCopyHistorySchema, 'body'),
  copyHistoryController.create
);

module.exports = router;
