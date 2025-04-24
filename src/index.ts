import express from 'express';
import http from 'node:http';
import dotenv from 'dotenv';
import { setupStreamServer } from './services/stream';
import { setupRoutes } from './routes';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

const server = http.createServer(app);

setupRoutes(app);

server.listen(PORT, () => {
  console.log(`HTTP server running on port ${PORT}`);
});

setupStreamServer();

process.on('SIGTERM', () => {
  console.log('SIGTERM signal received: closing HTTP server');
  server.close(() => {
    console.log('HTTP server closed');
    process.exit(0);
  });
});