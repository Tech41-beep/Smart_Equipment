import { Router } from 'express';
import equipmentRoutes from './equipment.routes.js';

const router = Router();
router.get('/health', (_req, res) => res.json({ status: 'ok' }));
router.use('/equipment', equipmentRoutes);
export default router;

