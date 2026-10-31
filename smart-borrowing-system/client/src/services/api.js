const API_BASE = import.meta.env.VITE_API_URL ?? '/api';
const SESSION_KEY = 'smart-borrowing-session';

function getToken() {
  try {
    return JSON.parse(localStorage.getItem(SESSION_KEY) || 'null')?.token;
  } catch {
    return null;
  }
}

export async function apiRequest(path, options = {}) {
  const token = getToken();
  const response = await fetch(`${API_BASE}${path}`, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...options.headers,
    },
  });

  const data = await response.json().catch(() => ({}));
  if (!response.ok) {
    throw new Error(data.message || data.error || `Request failed (${response.status})`);
  }
  return data;
}

