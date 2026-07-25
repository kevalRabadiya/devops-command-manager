const { Prisma } = require('@prisma/client');
const prisma = require('../lib/prisma');

async function getAll({ page = 1, limit = 20, category } = {}) {
  const where = category ? { category } : {};
  const skip = (page - 1) * limit;

  const [total, data] = await Promise.all([
    prisma.commands.count({ where }),
    prisma.commands.findMany({
      where,
      orderBy: { name: 'asc' },
      skip,
      take: limit,
    }),
  ]);

  return { data, total, page, limit };
}

async function getById(id) {
  return prisma.commands.findUnique({
    where: { id: Number(id) },
  });
}

async function search(searchQuery, { page = 1, limit = 20, category } = {}) {
  const offset = (page - 1) * limit;
  const pattern = `%${searchQuery}%`;
  const categoryFilter = category
    ? Prisma.sql`AND category = ${category}`
    : Prisma.empty;

  const countRows = await prisma.$queryRaw`
    SELECT COUNT(*)::int AS total
    FROM devops_cli.commands
    WHERE (
         name ILIKE ${pattern}
       OR description ILIKE ${pattern}
       OR command_template ILIKE ${pattern}
       OR EXISTS (
         SELECT 1 FROM unnest(COALESCE(tags, ARRAY[]::text[])) AS tag
         WHERE tag ILIKE ${pattern}
       )
    )
    ${categoryFilter}
  `;

  const data = await prisma.$queryRaw`
    SELECT *
    FROM devops_cli.commands
    WHERE (
         name ILIKE ${pattern}
       OR description ILIKE ${pattern}
       OR command_template ILIKE ${pattern}
       OR EXISTS (
         SELECT 1 FROM unnest(COALESCE(tags, ARRAY[]::text[])) AS tag
         WHERE tag ILIKE ${pattern}
       )
    )
    ${categoryFilter}
    ORDER BY name ASC
    LIMIT ${limit} OFFSET ${offset}
  `;

  return {
    data,
    total: countRows[0].total,
    page,
    limit,
  };
}

async function create(data) {
  const {
    name,
    description,
    command_template,
    category,
    tags = [],
    example,
    syntax_help,
    properties = [],
  } = data;

  return prisma.commands.create({
    data: {
      name,
      description,
      command_template,
      category,
      tags,
      example,
      syntax_help,
      properties:
        properties.length > 0
          ? {
              create: properties.map((prop) => ({
                property_name: prop.property_name,
                property_type: prop.property_type,
                default_value: prop.default_value ?? null,
                is_required: prop.is_required ?? false,
                placeholder: prop.placeholder ?? null,
                description: prop.description ?? null,
                select_options: prop.select_options ?? Prisma.JsonNull,
                validation_pattern: prop.validation_pattern ?? null,
                display_order: prop.display_order ?? null,
              })),
            }
          : undefined,
    },
  });
}

async function update(id, data) {
  const allowed = [
    'name',
    'description',
    'command_template',
    'category',
    'tags',
    'example',
    'syntax_help',
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
    return await prisma.commands.update({
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

async function remove(id) {
  try {
    return await prisma.commands.delete({
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
  search,
  create,
  update,
  delete: remove,
};
