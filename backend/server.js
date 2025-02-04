const express = require('express');
const cors = require('cors');

const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

let todos = [];
let idCounter = 1;

// Get all todos
app.get('/todos', (req, res) => {
    res.json(todos);
});

// Add a new todo
app.post('/todos', (req, res) => {
    const { text } = req.body;
    if (!text) {
        return res.status(400).json({ error: 'Text is required' });
    }
    const newTodo = { id: idCounter++, text, completed: false };
    todos.push(newTodo);
    res.status(201).json(newTodo);
});

// Toggle completion
app.patch('/todos/:id', (req, res) => {
    const { id } = req.params;
    const todo = todos.find(t => t.id == id);
    if (!todo) {
        return res.status(404).json({ error: 'Todo not found' });
    }
    todo.completed = !todo.completed;
    res.json(todo);
});

// Delete a todo
app.delete('/todos/:id', (req, res) => {
    const { id } = req.params;
    todos = todos.filter(t => t.id != id);
    res.json({ message: 'Todo deleted' });
});

app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
