const prisma = require('../lib/prisma');

function withCommandCount(category) {
  if (!category) return null;
  const { _count, ...rest } = category;
  return { ...rest, command_count: _count?.commands ?? 0 };
}

async function getAll() {
  const categories = await prisma.categories.findMany({
    orderBy: { name: 'asc' },
    include: { _count: { select: { commands: true } } },
  });

  return categories.map(withCommandCount);
}

async function getById(id) {
  const category = await prisma.categories.findUnique({
    where: { id: Number(id) },
    include: { _count: { select: { commands: true } } },
  });

  return withCommandCount(category);
}

async function create(data) {
  const { name, description, icon, color } = data;

  const category = await prisma.categories.create({
    data: {
      name,
      description: description || null,
      icon: icon || null,
      color: color || null,
    },
  });

  return withCommandCount({ ...category, _count: { commands: 0 } });
}

async function update(id, data) {
  const allowed = ['name', 'description', 'icon', 'color'];

  const payload = {};
  for (const key of allowed) {
    if (Object.prototype.hasOwnProperty.call(data, key)) {
      payload[key] = data[key] || null;
    }
  }

  if (Object.keys(payload).length === 0) {
    return getById(id);
  }

  try {
    await prisma.categories.update({
      where: { id: Number(id) },
      data: payload,
    });
    return getById(id);
  } catch (err) {
    if (err.code === 'P2025') {
      return null;
    }
    throw err;
  }
}

async function remove(id) {
  try {
    return await prisma.categories.delete({
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
  update,
  delete: remove,
};
