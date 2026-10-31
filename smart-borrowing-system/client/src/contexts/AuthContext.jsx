import { createContext, useContext, useMemo, useState } from 'react';
import { authService } from '../services/authService.js';

const AuthContext = createContext(null);
const SESSION_KEY = 'smart-borrowing-session';

function readSession() {
  try {
    const session = JSON.parse(localStorage.getItem(SESSION_KEY) || 'null');
    if (!session?.token || !session?.user) return null;
    return session;
  } catch {
    return null;
  }
}

export function AuthProvider({ children }) {
  const [session, setSession] = useState(readSession);

  async function login(email, password) {
    const result = await authService.login(email, password);
    const nextSession = { token: result.token, user: result.user };
    localStorage.setItem(SESSION_KEY, JSON.stringify(nextSession));
    setSession(nextSession);
    return nextSession.user;
  }

  function logout() {
    localStorage.removeItem(SESSION_KEY);
    setSession(null);
  }

  const value = useMemo(
    () => ({
      user: session?.user ?? null,
      token: session?.token ?? null,
      isAuthenticated: Boolean(session?.token && session?.user),
      login,
      logout,
    }),
    [session],
  );
  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) throw new Error('useAuth must be used inside AuthProvider');
  return context;
}

