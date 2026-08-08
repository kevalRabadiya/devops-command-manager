import apiClient from './apiClient';

export async function list({ limit = 20 } = {}) {
  const { data } = await apiClient.get('/copy-history', { params: { limit } });
  return data;
}

export async function create(payload) {
  const { data } = await apiClient.post('/copy-history', payload);
  return data;
}

const copyHistoryService = {
  list,
  create,
};

export default copyHistoryService;
