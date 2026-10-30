import { prisma } from '../src/config/database.js';

async function main() {
  const category = await prisma.category.upsert({
    where: { name: 'General' },
    update: {},
    create: { name: 'General' },
  });
  await prisma.equipment.upsert({
    where: { assetTag: 'DEMO-001' },
    update: {},
    create: {
      name: 'Demo equipment',
      assetTag: 'DEMO-001',
      description: 'Replace this sample with your inventory.',
      categoryId: category.id,
    },
  });
}

main().finally(() => prisma.$disconnect());

