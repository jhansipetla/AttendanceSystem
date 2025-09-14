import { Router } from 'express';
import { prisma } from '../../config/prisma.js';
import { requireAuth, AuthRequest } from '../../middlewares/auth.js';
import { z } from 'zod';

export const studentsRouter = Router();

studentsRouter.get('/me', requireAuth(['STUDENT']), async (req: AuthRequest, res) => {
  const userId = req.user!.userId;
  const user = await prisma.user.findUnique({ where: { id: userId }, include: { student: true } });
  if (!user?.student) return res.status(404).json({ error: 'Student profile not found' });
  return res.json({
    id: user.student.id,
    regNo: user.student.regNo,
    name: user.student.name,
    year: user.student.year,
    branch: user.student.branch,
    section: user.student.section,
    email: user.email,
  });
});

const updateSchema = z.object({
  name: z.string().min(1).optional(),
  year: z.string().optional(),
  branch: z.string().optional(),
  section: z.string().optional(),
});

studentsRouter.put('/me', requireAuth(['STUDENT']), async (req: AuthRequest, res) => {
  const parsed = updateSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.flatten() });
  const userId = req.user!.userId;
  const user = await prisma.user.findUnique({ where: { id: userId }, include: { student: true } });
  if (!user?.student) return res.status(404).json({ error: 'Student profile not found' });
  const updated = await prisma.student.update({ where: { id: user.student.id }, data: parsed.data });
  return res.json(updated);
});


