import { z } from 'zod';

export const equipmentQuerySchema = z.object({
  search: z.string().trim().optional(),
});

