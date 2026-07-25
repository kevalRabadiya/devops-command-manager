import apiClient from './apiClient';

export async function getAll({ page = 1, limit = 20, category } = {}) {
  const params = { page, limit };
  if (category) params.category = category;
  const { data } = await apiClient.get('/commands', { params });
  return data;
}

export async function search(q, { page = 1, limit = 20, category } = {}) {
  const params = { q, page, limit };
  if (category) params.category = category;
  const { data } = await apiClient.get('/commands/search', { params });
  return data;
}

export async function getById(id) {
  const { data } = await apiClient.get(`/commands/${id}`);
  return data;
}

export async function create(payload) {
  const { data } = await apiClient.post('/commands', payload);
  return data;
}

export async function update(id, payload) {
  const { data } = await apiClient.put(`/commands/${id}`, payload);
  return data;
}

export async function remove(id) {
  const { data } = await apiClient.delete(`/commands/${id}`);
  return data;
}

const commandService = {
  getAll,
  search,
  getById,
  create,
  update,
  remove,
};

export default commandService;
