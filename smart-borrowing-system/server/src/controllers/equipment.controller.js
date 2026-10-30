import { listEquipment } from '../services/equipment.service.js';
import { equipmentQuerySchema } from '../validators/equipment.validator.js';

export async function getEquipment(req, res) {
  const query = equipmentQuerySchema.parse(req.query);
  const items = await listEquipment(query.search);
  res.json(items);
}

