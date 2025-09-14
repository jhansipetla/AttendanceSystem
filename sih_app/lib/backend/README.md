Setup

1) Copy .env.example to .env and edit values
2) npm install
3) npx prisma generate
4) npx prisma migrate dev --name init
5) npm run dev

Key endpoints
- POST /auth/register
- POST /auth/login
- GET /students/me (Bearer token)
- PUT /students/me (Bearer token)
- POST /attendance/sessions (faculty/admin)
- POST /attendance/mark (student)

Flutter integration (summary)
- After student registration screen, call POST /auth/register with role STUDENT and student fields
- Then call POST /auth/login to receive tokens
- Save accessToken; send in Authorization: Bearer headers for protected calls
- To show profile on dashboard, call GET /students/me with token and display returned fields

