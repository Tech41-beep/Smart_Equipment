const API_BASE = import.meta.env.VITE_API_URL ?? '/api';

export async function apiRequest(path, options = {}) {
  const response = await fetch(`${API_BASE}${path}`, {
    ...options,
    headers: { 'Content-Type': 'application/json', ...options.headers },
  });
  if (!response.ok) throw new Error(`API request failed (${response.status})`);
  return response.json();
}

