import { apiRequest } from './api.js';

export const equipmentService = {
  list: () => apiRequest('/equipment'),
};

