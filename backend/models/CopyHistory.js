const prisma = require('../lib/prisma');

const commandSelect = { id: true, name: true, category: true };
const templateSelect = { id: true, template_name: true };

const RETENTION_LIMIT = 100;

async function getRecent({ limit = 20 } = {}) {
  const take = Math.min(Math.max(Number(limit) || 20, 1), 20);

  const data = await prisma.copy_history.findMany({
    include: {
      command: { select: commandSelect },
      template: { select: templateSelect },
    },
    orderBy: { copied_at: 'desc' },
    take,
  });

  return { data, total: data.length, limit: take };
}

async function create(data) {
  const {
    command_id,
    copied_command,
    property_values,
    command_template_id,
  } = data;

  const entry = await prisma.copy_history.create({
    data: {
      command_id: Number(command_id),
      copied_command,
      property_values: property_values ?? undefined,
      command_template_id: command_template_id
        ? Number(command_template_id)
        : null,
    },
    include: {
      command: { select: commandSelect },
      template: { select: templateSelect },
    },
  });

  await trimOldEntries();

  return entry;
}

async function trimOldEntries() {
  const keepIds = await prisma.copy_history.findMany({
    select: { id: true },
    orderBy: { copied_at: 'desc' },
    take: RETENTION_LIMIT,
  });

  const idsToKeep = keepIds.map((row) => row.id);
  if (idsToKeep.length === 0) return;

  await prisma.copy_history.deleteMany({
    where: { id: { notIn: idsToKeep } },
  });
}

module.exports = {
  getRecent,
  create,
};
