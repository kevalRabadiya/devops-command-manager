const express = require('express');
const featureRequestController = require('../controllers/featureRequestController');
const { validate } = require('../middleware/validate');
const {
  createFeatureRequestSchema,
  updateFeatureRequestSchema,
  listQuerySchema,
  voteSchema,
  idParamSchema,
} = require('../validators/featureRequestSchemas');

const router = express.Router();

router.get('/', validate(listQuerySchema, 'query'), featureRequestController.getAll);
router.post(
  '/',
  validate(createFeatureRequestSchema, 'body'),
  featureRequestController.create
);
router.put(
  '/:id',
  validate(idParamSchema, 'params'),
  validate(updateFeatureRequestSchema, 'body'),
  featureRequestController.update
);
router.post(
  '/:id/vote',
  validate(idParamSchema, 'params'),
  validate(voteSchema, 'body'),
  featureRequestController.vote
);

module.exports = router;
