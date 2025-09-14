import { createApp } from './app.js';
import dotenv from 'dotenv';

dotenv.config();

const app = createApp();
const port = Number(process.env.PORT || 4000);

app.listen(port, () => {
  console.log(`API listening on http://localhost:${port}`);
});


