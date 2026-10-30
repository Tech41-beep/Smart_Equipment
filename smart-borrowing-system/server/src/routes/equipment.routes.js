import { Router } from 'express';
import { getEquipment } from '../controllers/equipment.controller.js';
import { asyncHandler } from '../utils/asyncHandler.js';

const router = Router();
router.get('/', asyncHandler(getEquipment));
export default router;

