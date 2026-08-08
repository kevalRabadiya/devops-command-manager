import apiClient from './apiClient';

export async function list({ page = 1, limit = 20, command_id } = {}) {
  const params = { page, limit };
  if (command_id) params.command_id = command_id;
  const { data } = await apiClient.get('/templates', { params });
  return data;
}

export async function getById(id) {
  const { data } = await apiClient.get(`/templates/${id}`);
  return data;
}

export async function create(payload) {
  const { data } = await apiClient.post('/templates', payload);
  return data;
}

export async function remove(id) {
  const { data } = await apiClient.delete(`/templates/${id}`);
  return data;
}

const templateService = {
  list,
  getById,
  create,
  remove,
};

export default templateService;
