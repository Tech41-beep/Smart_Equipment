import { NavLink, Outlet, useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext.jsx';

export default function AdminLayout() {
  const { logout, user } = useAuth();
  const navigate = useNavigate();
  function handleLogout() { logout(); navigate('/login', { replace: true }); }
  return <div className="shell"><header className="topbar"><NavLink to="/admin">Equipment Admin</NavLink><nav className="nav"><NavLink to="/admin">Dashboard</NavLink><NavLink to="/admin/equipment">Equipment</NavLink></nav><div className="account"><span>{user?.name || user?.email}</span><button className="button-link" onClick={handleLogout}>Sign out</button></div></header><main className="content"><Outlet /></main></div>;
}

