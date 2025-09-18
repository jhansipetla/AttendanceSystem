import { Router } from 'express';
import { prisma } from '../../config/prisma.js';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { z } from 'zod';

export const authRouter = Router();

const registerSchema = z.object({
  email: z.string().email(),
  password: z.string().min(6),
  role: z.enum(['STUDENT', 'FACULTY', 'ADMIN']).default('STUDENT'),
  student: z
    .object({ regNo: z.string(), name: z.string(), phone: z.string(), year: z.string(), branch: z.string(), section: z.string() })
    .optional(),
  faculty: z.object({ name: z.string(), department: z.string() }).optional(),
});

authRouter.post('/register', async (req, res) => {
  const parsed = registerSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.flatten() });
  const { email, password, role, student, faculty } = parsed.data;

  const existing = await prisma.user.findUnique({ where: { email } });
  if (existing) return res.status(409).json({ error: 'Email already registered' });

  const passwordHash = await bcrypt.hash(password, 10);
  const created = await prisma.$transaction(async (tx) => {
    const user = await tx.user.create({ data: { email, passwordHash, role } });
    if (role === 'STUDENT' && student) {
      await tx.student.create({ data: { userId: user.id, ...student } });
    }
    if (role === 'FACULTY' && faculty) {
      await tx.faculty.create({ data: { userId: user.id, ...faculty } });
    }
    return user;
  });

  return res.json({ id: created.id, email: created.email, role: created.role });
});

// Allow login by either email+password or regNo+phone
const loginSchema = z.object({
  email: z.string().email().optional(),
  password: z.string().min(6).optional(),
  regNo: z.string().optional(),
  phone: z.string().optional(),
}).refine((d) => (d.email && d.password) || (d.regNo && d.phone), {
  message: 'Provide email+password or regNo+phone',
});

authRouter.post('/login', async (req, res) => {
  const parsed = loginSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.flatten() });
  const { email, password, regNo, phone } = parsed.data as any;

  let user = null as any;
  if (email && password) {
    user = await prisma.user.findUnique({ where: { email }, include: { student: true, faculty: true } });
    if (!user) return res.status(401).json({ error: 'Invalid credentials' });
    const ok = await bcrypt.compare(password, user.passwordHash);
    if (!ok) return res.status(401).json({ error: 'Invalid credentials' });
  } else if (regNo && phone) {
    const student = await prisma.student.findUnique({ where: { regNo }, include: { user: true } });
    if (!student || student.phone !== phone) return res.status(401).json({ error: 'Invalid credentials' });
    user = await prisma.user.findUnique({ where: { id: student.userId }, include: { student: true } });
  }

  const access = jwt.sign({ userId: user.id, role: user.role }, process.env.JWT_ACCESS_SECRET || 'dev', {
    expiresIn: '15m',
  });
  const refresh = jwt.sign({ userId: user.id, role: user.role }, process.env.JWT_REFRESH_SECRET || 'dev', {
    expiresIn: '7d',
  });

  return res.json({
    accessToken: access,
    refreshToken: refresh,
    user: {
      id: user.id,
      email: user.email,
      role: user.role,
      student: user.student,
      faculty: user.faculty,
    },
  });
});

// Simple password reset using regNo + phone
const resetSchema = z.object({ regNo: z.string(), phone: z.string(), newPassword: z.string().min(6) });

authRouter.post('/reset-password', async (req, res) => {
  const parsed = resetSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.flatten() });
  const { regNo, phone, newPassword } = parsed.data;
  const student = await prisma.student.findUnique({ where: { regNo }, include: { user: true } });
  if (!student || student.phone !== phone) return res.status(401).json({ error: 'Verification failed' });
  const passwordHash = await bcrypt.hash(newPassword, 10);
  await prisma.user.update({ where: { id: student.userId }, data: { passwordHash } });
  return res.json({ ok: true });
});

authRouter.post('/refresh', async (req, res) => {
  const token = req.body.refreshToken as string | undefined;
  if (!token) return res.status(400).json({ error: 'Missing refreshToken' });
  try {
    const decoded = jwt.verify(token, process.env.JWT_REFRESH_SECRET || 'dev') as { userId: string; role: string };
    const access = jwt.sign({ userId: decoded.userId, role: decoded.role }, process.env.JWT_ACCESS_SECRET || 'dev', {
      expiresIn: '15m',
    });
    return res.json({ accessToken: access });
  } catch (e) {
    return res.status(401).json({ error: 'Invalid refresh token' });
  }
});


