import { Navigate, Outlet, useLocation } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext.jsx';

export function homeForRole(role) {
  if (role === 'ADMIN' || role === 'SUPER_ADMIN') return '/admin';
  if (role === 'STUDENT' || role === 'STAFF') return '/borrower';
  return '/login';
}

export default function ProtectedRoute({ allowedRoles, children }) {
  const { user, isAuthenticated } = useAuth();
  const location = useLocation();

  if (!isAuthenticated) {
    return <Navigate to="/login" replace state={{ from: location }} />;
  }

  if (allowedRoles && !allowedRoles.includes(user.role)) {
    return <Navigate to={homeForRole(user.role)} replace />;
  }

  return children ?? <Outlet />;
}
