import apiClient from './apiClient';

export async function getAll({ page = 1, limit = 20, status, category } = {}) {
  const params = { page, limit };
  if (status) params.status = status;
  if (category) params.category = category;
  const { data } = await apiClient.get('/feature-requests', { params });
  return data;
}

export async function create(payload) {
  const { data } = await apiClient.post('/feature-requests', payload);
  return data;
}

export async function update(id, payload) {
  const { data } = await apiClient.put(`/feature-requests/${id}`, payload);
  return data;
}

export async function vote(id, direction) {
  const { data } = await apiClient.post(`/feature-requests/${id}/vote`, {
    direction,
  });
  return data;
}

const featureRequestService = {
  getAll,
  create,
  update,
  vote,
};

export default featureRequestService;
