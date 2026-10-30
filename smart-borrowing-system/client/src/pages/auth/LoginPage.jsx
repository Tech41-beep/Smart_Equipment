import { Link } from 'react-router-dom';

export default function LoginPage() {
  return <main className="content"><section className="card"><h1>Smart Borrowing System</h1><p className="muted">Sign-in will connect to the authentication API.</p><p><Link to="/borrower">Open borrower workspace</Link> · <Link to="/admin">Open admin workspace</Link></p></section></main>;
}

