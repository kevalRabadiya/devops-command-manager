const Category = require('../models/Category');

async function getAll(req, res, next) {
  try {
    const categories = await Category.getAll();
    res.json(categories);
  } catch (err) {
    next(err);
  }
}

async function create(req, res, next) {
  try {
    const category = await Category.create(req.body);
    res.status(201).json(category);
  } catch (err) {
    next(err);
  }
}

async function update(req, res, next) {
  try {
    const category = await Category.update(req.params.id, req.body);
    if (!category) {
      return res.status(404).json({ error: 'Category not found' });
    }
    return res.json(category);
  } catch (err) {
    return next(err);
  }
}

async function remove(req, res, next) {
  try {
    const category = await Category.delete(req.params.id);
    if (!category) {
      return res.status(404).json({ error: 'Category not found' });
    }
    return res.json({ message: 'Category deleted', category });
  } catch (err) {
    return next(err);
  }
}

module.exports = {
  getAll,
  create,
  update,
  delete: remove,
};
