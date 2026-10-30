import { useEffect, useState } from 'react';
import { equipmentService } from '../../services/equipmentService.js';

export default function EquipmentPage() {
  const [equipment, setEquipment] = useState([]);
  const [error, setError] = useState('');
  useEffect(() => { equipmentService.list().then(setEquipment).catch(() => setError('Equipment API is not available yet.')); }, []);
  return <section><h1>Equipment</h1>{error && <p className="muted">{error}</p>}<div className="card">{equipment.length ? equipment.map((item) => <p key={item.id}>{item.name} · {item.availableQuantity} available</p>) : 'Equipment records will appear here.'}</div></section>;
}

