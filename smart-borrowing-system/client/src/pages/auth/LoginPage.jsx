import { useState } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import { useAuth } from '../../contexts/AuthContext.jsx';
import { homeForRole } from '../../routes/ProtectedRoute.jsx';

export default function LoginPage() {
  const { login } = useAuth();
  const location = useLocation();
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  async function handleSubmit(event) {
    event.preventDefault();
    setError('');
    setIsSubmitting(true);
    try {
      const user = await login(email, password);
      const roleHome = homeForRole(user.role);
      if (roleHome === '/login') {
        setError('Your account does not have access to this application.');
        return;
      }
      const requestedPath = location.state?.from?.pathname;
      const isAllowedPath = requestedPath === roleHome || requestedPath?.startsWith(`${roleHome}/`);
      navigate(isAllowedPath ? requestedPath : roleHome, { replace: true });
    } catch (loginError) {
      setError(loginError.message || 'Unable to sign in. Please try again.');
    } finally {
      setIsSubmitting(false);
    }
  }

  return (
    <main className="content login-page">
      <section className="card login-card">
        <h1>Sign in</h1>
        <p className="muted">Use your Smart Borrowing System account.</p>
        <form className="login-form" onSubmit={handleSubmit}>
          <label htmlFor="email">Email</label>
          <input id="email" name="email" type="email" autoComplete="username" value={email} onChange={(event) => setEmail(event.target.value)} required />
          <label htmlFor="password">Password</label>
          <input id="password" name="password" type="password" autoComplete="current-password" value={password} onChange={(event) => setPassword(event.target.value)} required />
          {error && <p className="form-error" role="alert">{error}</p>}
          <button type="submit" disabled={isSubmitting}>{isSubmitting ? 'Signing in…' : 'Sign in'}</button>
        </form>
      </section>
    </main>
  );
}

