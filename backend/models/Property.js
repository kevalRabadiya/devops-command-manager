const { Prisma } = require('@prisma/client');
const prisma = require('../lib/prisma');

async function getByCommandId(commandId) {
  return prisma.command_properties.findMany({
    where: { command_id: Number(commandId) },
    orderBy: [
      { display_order: { sort: 'asc', nulls: 'last' } },
      { id: 'asc' },
    ],
  });
}

async function create(data) {
  const {
    command_id,
    property_name,
    property_type,
    default_value = null,
    is_required = false,
    placeholder = null,
    description = null,
    select_options = null,
    validation_pattern = null,
    display_order = null,
  } = data;

  return prisma.command_properties.create({
    data: {
      command_id: Number(command_id),
      property_name,
      property_type,
      default_value,
      is_required,
      placeholder,
      description,
      select_options: select_options ?? Prisma.JsonNull,
      validation_pattern,
      display_order,
    },
  });
}

async function update(id, data) {
  const allowed = [
    'property_name',
    'property_type',
    'default_value',
    'is_required',
    'placeholder',
    'description',
    'select_options',
    'validation_pattern',
    'display_order',
  ];

  const payload = {};
  for (const key of allowed) {
    if (Object.prototype.hasOwnProperty.call(data, key)) {
      if (key === 'select_options') {
        payload[key] = data[key] ?? Prisma.JsonNull;
      } else {
        payload[key] = data[key];
      }
    }
  }

  if (Object.keys(payload).length === 0) {
    return prisma.command_properties.findUnique({
      where: { id: Number(id) },
    });
  }

  try {
    return await prisma.command_properties.update({
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
    return await prisma.command_properties.delete({
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
  getByCommandId,
  create,
  update,
  delete: remove,
};
