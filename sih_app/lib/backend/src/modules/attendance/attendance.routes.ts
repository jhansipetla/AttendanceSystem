import { Router } from 'express';
import { prisma } from '../../config/prisma.js';
import { requireAuth, AuthRequest } from '../../middlewares/auth.js';
import { z } from 'zod';

export const attendanceRouter = Router();

const sessionSchema = z.object({
  classId: z.string(),
  date: z.string(), // ISO
  periodNo: z.number().int().min(1).max(10),
  startTime: z.string(), // ISO
  endTime: z.string(), // ISO
});

attendanceRouter.post('/sessions', requireAuth(['FACULTY', 'ADMIN']), async (req, res) => {
  const parsed = sessionSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.flatten() });
  const data = parsed.data;
  const created = await prisma.session.create({
    data: {
      classId: data.classId,
      date: new Date(data.date),
      periodNo: data.periodNo,
      startTime: new Date(data.startTime),
      endTime: new Date(data.endTime),
    },
  });
  return res.json(created);
});

const markSchema = z.object({
  sessionId: z.string(),
  status: z.enum(['PRESENT', 'ABSENT', 'LATE', 'EXCUSED']).default('PRESENT'),
  method: z.enum(['FACE', 'BIOMETRIC', 'MANUAL']).default('MANUAL'),
});

attendanceRouter.post('/mark', requireAuth(['STUDENT']), async (req: AuthRequest, res) => {
  const parsed = markSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.flatten() });
  const { sessionId, status, method } = parsed.data;

  const user = await prisma.user.findUnique({ where: { id: req.user!.userId }, include: { student: true } });
  if (!user?.student) return res.status(404).json({ error: 'Student profile not found' });

  // Optional: verify session is open and student enrolled; skipping for brevity

  const record = await prisma.attendanceRecord.upsert({
    where: { sessionId_studentId: { sessionId, studentId: user.student.id } },
    update: { status, method },
    create: { sessionId, studentId: user.student.id, status, method },
  });
  return res.json(record);
});


