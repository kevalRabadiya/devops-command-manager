const prisma = require('../lib/prisma');

async function getAll({ page = 1, limit = 20, status, category } = {}) {
  const where = {};
  if (status) where.status = status;
  if (category) where.category = category;

  const skip = (page - 1) * limit;

  const [total, data] = await Promise.all([
    prisma.feature_requests.count({ where }),
    prisma.feature_requests.findMany({
      where,
      orderBy: [{ votes_up: 'desc' }, { requested_at: 'desc' }],
      skip,
      take: limit,
    }),
  ]);

  return { data, total, page, limit };
}

async function getById(id) {
  return prisma.feature_requests.findUnique({
    where: { id: Number(id) },
  });
}

async function create(data) {
  const {
    title,
    description,
    command_example,
    category,
    priority = 'medium',
    requested_by = 'anonymous',
  } = data;

  return prisma.feature_requests.create({
    data: {
      title,
      description,
      command_example,
      category,
      priority,
      requested_by,
    },
  });
}

async function update(id, data) {
  const allowed = [
    'title',
    'description',
    'command_example',
    'category',
    'priority',
    'status',
    'notes',
  ];

  const payload = {};
  for (const key of allowed) {
    if (Object.prototype.hasOwnProperty.call(data, key)) {
      payload[key] = data[key];
    }
  }

  if (Object.keys(payload).length === 0) {
    return getById(id);
  }

  try {
    return await prisma.feature_requests.update({
      where: { id: Number(id) },
      data: payload,
    });
  } catch (err) {
    if (err.code === 'P2025') {
      return null;
    }
    throw err;
  }
}

async function vote(id, direction) {
  const field = direction === 'down' ? 'votes_down' : 'votes_up';

  try {
    return await prisma.feature_requests.update({
      where: { id: Number(id) },
      data: { [field]: { increment: 1 } },
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
  vote,
};
