const prisma = require('../lib/prisma');
const Command = require('./Command');

const AUTO_APPROVE_PRIORITY = 'highest';
const DEFAULT_CATEGORY = 'General';

async function resolveCategoryName(categoryName) {
  const name = (categoryName || '').trim() || DEFAULT_CATEGORY;
  const existing = await prisma.categories.findUnique({ where: { name } });
  if (existing) return existing.name;

  const created = await prisma.categories.create({ data: { name } });
  return created.name;
}

async function uniqueCommandName(baseName) {
  const base = baseName.trim().slice(0, 255) || 'Untitled command';
  let name = base;
  let suffix = 1;

  // eslint-disable-next-line no-await-in-loop
  while (await prisma.commands.findUnique({ where: { name } })) {
    suffix += 1;
    name = `${base} (${suffix})`.slice(0, 255);
  }

  return name;
}

// Highest-priority requests skip manual review: they're approved immediately
// and, when they include an example command, added straight to the commands list.
async function autoApprove(featureRequest) {
  let notes;

  try {
    if (!featureRequest.command_example || !featureRequest.command_example.trim()) {
      notes =
        'Auto-approved (highest priority). Add an example command to this request to auto-generate the command entry.';
    } else {
      const categoryName = await resolveCategoryName(featureRequest.category);
      const name = await uniqueCommandName(featureRequest.title);
      const template = featureRequest.command_example.trim();

      await Command.create({
        name,
        description: featureRequest.description,
        command_template: template,
        category: categoryName,
        example: template,
      });

      notes = `Auto-approved (highest priority) and added to commands as "${name}".`;
    }

    return prisma.feature_requests.update({
      where: { id: featureRequest.id },
      data: { status: 'approved', notes },
    });
  } catch (err) {
    return prisma.feature_requests.update({
      where: { id: featureRequest.id },
      data: {
        status: 'approved',
        notes: `Auto-approved (highest priority), but automatic command creation failed: ${err.message}`,
      },
    });
  }
}

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

  const featureRequest = await prisma.feature_requests.create({
    data: {
      title,
      description,
      command_example,
      category,
      priority,
      requested_by,
    },
  });

  if (priority === AUTO_APPROVE_PRIORITY) {
    return autoApprove(featureRequest);
  }

  return featureRequest;
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
