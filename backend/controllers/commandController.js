const Command = require('../models/Command');
const Property = require('../models/Property');

async function getAll(req, res, next) {
  try {
    const result = await Command.getAll(req.query);
    res.json(result);
  } catch (err) {
    next(err);
  }
}

async function search(req, res, next) {
  try {
    const { q, page, limit, category } = req.query;
    const result = await Command.search(q, { page, limit, category });
    res.json(result);
  } catch (err) {
    next(err);
  }
}

async function getById(req, res, next) {
  try {
    const command = await Command.getById(req.params.id);
    if (!command) {
      return res.status(404).json({ error: 'Command not found' });
    }

    const properties = await Property.getByCommandId(command.id);
    return res.json({ ...command, properties });
  } catch (err) {
    return next(err);
  }
}

async function create(req, res, next) {
  try {
    const command = await Command.create(req.body);
    const properties = await Property.getByCommandId(command.id);
    res.status(201).json({ ...command, properties });
  } catch (err) {
    next(err);
  }
}

async function update(req, res, next) {
  try {
    const command = await Command.update(req.params.id, req.body);
    if (!command) {
      return res.status(404).json({ error: 'Command not found' });
    }

    const properties = await Property.getByCommandId(command.id);
    return res.json({ ...command, properties });
  } catch (err) {
    return next(err);
  }
}

async function remove(req, res, next) {
  try {
    const command = await Command.delete(req.params.id);
    if (!command) {
      return res.status(404).json({ error: 'Command not found' });
    }
    return res.json({ message: 'Command deleted', command });
  } catch (err) {
    return next(err);
  }
}

module.exports = {
  getAll,
  search,
  getById,
  create,
  update,
  delete: remove,
};
