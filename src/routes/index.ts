import type { Express, Request, Response } from 'express';

/**
 * Setup all API routes for the server
 */
export function setupRoutes(app: Express): void {
  app.get('/health', (req: Request, res: Response) => {
    res.status(200).json({ status: 'ok' });
  });
}