import { Navigate, Route, Routes, useLocation } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext.jsx';
import AdminLayout from '../layouts/AdminLayout.jsx';
import BorrowerLayout from '../layouts/BorrowerLayout.jsx';
import LoginPage from '../pages/auth/LoginPage.jsx';
import AdminDashboardPage from '../pages/admin/AdminDashboardPage.jsx';
import EquipmentPage from '../pages/admin/EquipmentPage.jsx';
import StudentDashboardPage from '../pages/student/StudentDashboardPage.jsx';
import CatalogPage from '../pages/student/CatalogPage.jsx';
import ProtectedRoute, { homeForRole } from './ProtectedRoute.jsx';

function LoginRoute() {
  const { user } = useAuth();
  const location = useLocation();
  if (user) {
    const requestedPath = location.state?.from?.pathname;
    const roleHome = homeForRole(user.role);
    if (roleHome === '/login') return <LoginPage />;
    const isAllowedPath = requestedPath === roleHome || requestedPath?.startsWith(`${roleHome}/`);
    return <Navigate to={isAllowedPath ? requestedPath : roleHome} replace />;
  }
  return <LoginPage />;
}

export default function AppRoutes() {
  return (
    <Routes>
      <Route path="/login" element={<LoginRoute />} />
      <Route path="/admin" element={<ProtectedRoute allowedRoles={['ADMIN', 'SUPER_ADMIN']}><AdminLayout /></ProtectedRoute>}>
        <Route index element={<AdminDashboardPage />} />
        <Route path="equipment" element={<EquipmentPage />} />
      </Route>
      <Route path="/borrower" element={<ProtectedRoute allowedRoles={['STUDENT', 'STAFF']}><BorrowerLayout /></ProtectedRoute>}>
        <Route index element={<StudentDashboardPage />} />
        <Route path="catalog" element={<CatalogPage />} />
      </Route>
      <Route path="/" element={<HomeRedirect />} />
      <Route path="*" element={<Navigate to="/login" replace />} />
    </Routes>
  );
}

function HomeRedirect() {
  const { user } = useAuth();
  return <Navigate to={homeForRole(user?.role)} replace />;
}

