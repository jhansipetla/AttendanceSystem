import { Router } from "express";
import { z } from "zod";

// Helpers
const trim = (val: unknown) => (typeof val === "string" ? val.trim() : val);

// Schemas
const nameSchema = z.preprocess(
  trim,
  z
    .string()
    .min(1, "Name is required")
    .regex(
      /^[A-Za-z .'-]{2,60}$/u,
      "Name can contain letters and basic punctuation only"
    )
    .transform((val) => val.trim())
);

const emailSchema = z.preprocess(
  trim,
  z
    .string()
    .min(1, "Email is required")
    .email("Invalid email format")
    .transform((val) => val.toLowerCase())
);

const pinSchema = z.preprocess(
  trim,
  z
    .string()
    .min(4, "PIN must be at least 4 digits")
    .max(6, "PIN cannot be more than 6 digits")
    .regex(/^\d+$/, "PIN must contain only digits")
);

const registerSchema = z.object({
  name: nameSchema,
  email: emailSchema,
  pin: pinSchema,
});

const loginSchema = z.object({
  email: emailSchema,
  pin: pinSchema,
});

// Router
const router = Router();

router.post("/register", async (req, res) => {
  try {
    const { name, email, pin } = registerSchema.parse(req.body);

    // ⚠️ Plaintext storage (demo only)
    // If you want hashed PIN instead: use bcrypt.hash(pin, 10) here
    res.json({
      message: "User registered successfully",
      user: { name, email },
    });
  } catch (err: any) {
    res.status(400).json({ error: err.errors ?? err.message });
  }
});

router.post("/login", async (req, res) => {
  try {
    const { email, pin } = loginSchema.parse(req.body);

    // ⚠️ Replace with real DB check
    // If hashed: use bcrypt.compare(pin, storedPinHash)
    res.json({ message: "Login successful", user: { email } });
  } catch (err: any) {
    res.status(400).json({ error: err.errors ?? err.message });
  }
});

export default router;
