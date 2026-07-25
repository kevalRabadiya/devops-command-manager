function notFoundHandler(req, res, next) {
  res.status(404).json({ error: `Route not found: ${req.method} ${req.originalUrl}` });
}

function errorHandler(err, req, res, next) {
  console.error(err);

  if (err.code === '23505') {
    return res.status(409).json({ error: 'Resource already exists', details: err.detail });
  }

  if (err.code === '23503') {
    return res.status(400).json({ error: 'Invalid reference', details: err.detail });
  }

  const status = err.status || err.statusCode || 500;
  const payload = {
    error: err.message || 'Internal server error',
  };

  if (process.env.NODE_ENV !== 'production' && err.stack) {
    payload.stack = err.stack;
  }

  return res.status(status).json(payload);
}

module.exports = { notFoundHandler, errorHandler };
