require('dotenv').config();

const express = require('express');
const cors = require('cors');
const { requestLogger } = require('./middleware/requestLogger');
const { notFoundHandler, errorHandler } = require('./middleware/errorHandler');
const commandsRouter = require('./routes/commands');
const { connectDatabase } = require('./lib/prisma');

const app = express();
const PORT = Number(process.env.PORT) || 5000;

function resolveCorsOrigin() {
  const value = process.env.CORS_ORIGIN;
  if (!value || value.trim() === '*') {
    return true;
  }
  const origins = value.split(',').map((origin) => origin.trim()).filter(Boolean);
  return origins.length === 1 ? origins[0] : origins;
}

app.use(
  cors({
    origin: resolveCorsOrigin(),
  })
);
app.use(express.json());
app.use(requestLogger);

app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

app.use('/api/commands', commandsRouter);

app.use(notFoundHandler);
app.use(errorHandler);

async function start() {
  try {
    await connectDatabase();
    app.listen(PORT, () => {
      console.log(`Server running on http://localhost:${PORT}`);
    });
  } catch {
    console.error('[db] Server not started because the database is unreachable');
    process.exit(1);
  }
}

start();

module.exports = app;
