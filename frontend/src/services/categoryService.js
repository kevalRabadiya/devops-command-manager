import apiClient from './apiClient';

export async function getAll() {
  const { data } = await apiClient.get('/categories');
  return data;
}

export async function create(payload) {
  const { data } = await apiClient.post('/categories', payload);
  return data;
}

export async function update(id, payload) {
  const { data } = await apiClient.put(`/categories/${id}`, payload);
  return data;
}

export async function remove(id) {
  const { data } = await apiClient.delete(`/categories/${id}`);
  return data;
}

const categoryService = {
  getAll,
  create,
  update,
  remove,
};

export default categoryService;
