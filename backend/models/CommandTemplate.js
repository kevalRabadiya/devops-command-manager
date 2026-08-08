const prisma = require('../lib/prisma');

const commandSelect = { id: true, name: true, category: true };

async function getAll({ page = 1, limit = 20, command_id } = {}) {
  const where = {};
  if (command_id) {
    where.command_id = Number(command_id);
  }

  const skip = (page - 1) * limit;

  const [total, data] = await Promise.all([
    prisma.command_templates.count({ where }),
    prisma.command_templates.findMany({
      where,
      include: { command: { select: commandSelect } },
      orderBy: { updated_at: 'desc' },
      skip,
      take: limit,
    }),
  ]);

  return { data, total, page, limit };
}

async function getById(id) {
  return prisma.command_templates.findUnique({
    where: { id: Number(id) },
    include: { command: { select: commandSelect } },
  });
}

async function create(data) {
  const { command_id, template_name, property_values, description } = data;

  return prisma.command_templates.create({
    data: {
      command_id: Number(command_id),
      template_name,
      property_values,
      description: description ?? null,
    },
    include: { command: { select: commandSelect } },
  });
}

async function remove(id) {
  try {
    return await prisma.command_templates.delete({
      where: { id: Number(id) },
    });
  } catch (err) {
    if (err.code === 'P2025') {
      return null;
    }
    throw err;
  }
}

module.exports = {
  getAll,
  getById,
  create,
  delete: remove,
};
