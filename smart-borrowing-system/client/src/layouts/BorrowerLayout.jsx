import { NavLink, Outlet } from 'react-router-dom';

export default function BorrowerLayout() {
  return <div className="shell"><header className="topbar"><NavLink to="/borrower">My Borrowing</NavLink><nav className="nav"><NavLink to="/borrower">Overview</NavLink><NavLink to="/borrower/catalog">Equipment catalog</NavLink></nav></header><main className="content"><Outlet /></main></div>;
}

