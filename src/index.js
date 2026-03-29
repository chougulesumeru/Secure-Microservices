const express = require('express');
const app = express();
app.use(express.json());

let todos = [];

app.get('/health', (req, res) => res.json({ status: 'ok' }));
app.get('/todos', (req, res) => res.json(todos));
app.post('/todos', (req, res) => {
  const todo = { id: Date.now(), text: req.body.text, done: false };
  todos.push(todo);
  res.status(201).json(todo);
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Running on port ${PORT}`));