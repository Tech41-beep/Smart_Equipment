import { prisma } from '../config/database.js';

export function listEquipment(search) {
  return prisma.equipment.findMany({
    where: search ? { name: { contains: search } } : undefined,
    orderBy: { name: 'asc' },
  });
}

