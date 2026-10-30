import { NavLink, Outlet } from 'react-router-dom';

export default function AdminLayout() {
  return <div className="shell"><header className="topbar"><NavLink to="/admin">Equipment Admin</NavLink><nav className="nav"><NavLink to="/admin">Dashboard</NavLink><NavLink to="/admin/equipment">Equipment</NavLink></nav></header><main className="content"><Outlet /></main></div>;
}

