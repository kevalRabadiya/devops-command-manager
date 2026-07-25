const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

function describeDatabaseTarget(databaseUrl = process.env.DATABASE_URL) {
  if (!databaseUrl) {
    return { label: 'DATABASE_URL not set' };
  }

  try {
    const url = new URL(databaseUrl);
    const dbName = url.pathname.replace(/^\//, '') || '(unknown)';
    const port = url.port || '5432';
    return {
      label: `${url.hostname}:${port}/${dbName}`,
      host: url.hostname,
    };
  } catch {
    return { label: '(invalid DATABASE_URL)' };
  }
}

async function connectDatabase() {
  const { label } = describeDatabaseTarget();
  console.log(`[db] Connecting to ${label}...`);

  try {
    await prisma.$connect();
    await prisma.$queryRaw`SELECT 1`;
    console.log(`[db] Connected successfully to ${label}`);
  } catch (error) {
    console.error(`[db] Connection failed for ${label}`);
    console.error(`[db] ${error.message}`);
    throw error;
  }
}

module.exports = prisma;
module.exports.connectDatabase = connectDatabase;
