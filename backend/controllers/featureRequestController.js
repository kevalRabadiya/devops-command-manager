const FeatureRequest = require('../models/FeatureRequest');

async function getAll(req, res, next) {
  try {
    const result = await FeatureRequest.getAll(req.query);
    res.json(result);
  } catch (err) {
    next(err);
  }
}

async function create(req, res, next) {
  try {
    const featureRequest = await FeatureRequest.create(req.body);
    res.status(201).json(featureRequest);
  } catch (err) {
    next(err);
  }
}

async function update(req, res, next) {
  try {
    const featureRequest = await FeatureRequest.update(req.params.id, req.body);
    if (!featureRequest) {
      return res.status(404).json({ error: 'Feature request not found' });
    }
    return res.json(featureRequest);
  } catch (err) {
    return next(err);
  }
}

async function vote(req, res, next) {
  try {
    const featureRequest = await FeatureRequest.vote(
      req.params.id,
      req.body.direction
    );
    if (!featureRequest) {
      return res.status(404).json({ error: 'Feature request not found' });
    }
    return res.json(featureRequest);
  } catch (err) {
    return next(err);
  }
}

module.exports = {
  getAll,
  create,
  update,
  vote,
};
