import { Navigate, Route, Routes } from 'react-router-dom';
import AdminLayout from '../layouts/AdminLayout.jsx';
import BorrowerLayout from '../layouts/BorrowerLayout.jsx';
import LoginPage from '../pages/auth/LoginPage.jsx';
import AdminDashboardPage from '../pages/admin/AdminDashboardPage.jsx';
import EquipmentPage from '../pages/admin/EquipmentPage.jsx';
import BorrowerDashboardPage from '../pages/borrower/BorrowerDashboardPage.jsx';
import CatalogPage from '../pages/borrower/CatalogPage.jsx';

export default function AppRoutes() {
  return (
    <Routes>
      <Route path="/login" element={<LoginPage />} />
      <Route path="/admin" element={<AdminLayout />}>
        <Route index element={<AdminDashboardPage />} />
        <Route path="equipment" element={<EquipmentPage />} />
      </Route>
      <Route path="/borrower" element={<BorrowerLayout />}>
        <Route index element={<BorrowerDashboardPage />} />
        <Route path="catalog" element={<CatalogPage />} />
      </Route>
      <Route path="*" element={<Navigate to="/login" replace />} />
    </Routes>
  );
}

