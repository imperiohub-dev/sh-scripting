import { Router, Request, Response } from 'express';

const router = Router();

// GET /api/users
router.get('/', (req: Request, res: Response) => {
  res.json({
    message: 'Get all users',
    data: []
  });
});

// GET /api/users/:id
router.get('/:id', (req: Request, res: Response) => {
  const { id } = req.params;
  res.json({
    message: `Get user ${id}`,
    data: { id }
  });
});

// POST /api/users
router.post('/', (req: Request, res: Response) => {
  const body = req.body;
  res.status(201).json({
    message: 'User created',
    data: body
  });
});

// PUT /api/users/:id
router.put('/:id', (req: Request, res: Response) => {
  const { id } = req.params;
  const body = req.body;
  res.json({
    message: `User ${id} updated`,
    data: { id, ...body }
  });
});

// DELETE /api/users/:id
router.delete('/:id', (req: Request, res: Response) => {
  const { id } = req.params;
  res.json({
    message: `User ${id} deleted`
  });
});

export default router;
