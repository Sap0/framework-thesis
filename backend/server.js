const express = require("express");
const cors = require("cors");

const app = express();
app.use(express.json());
app.use(cors());

let todos = [];
let idCounter = 1;

// Get all todos
app.get("/todos", (req, res) => {
    res.json(todos);
});

// Add a new todo
app.post("/todos", (req, res) => {
    const { text } = req.body;
    if (!text) {
        return res.status(400).json({ error: "Text is required" });
    }
    const newTodo = { id: idCounter++, text, done: false };
    todos.push(newTodo);
    res.status(201).json(newTodo);
});

// Toggle todo completion
app.patch("/todos/:id", (req, res) => {
    const { id } = req.params;
    const todo = todos.find(t => t.id === parseInt(id));
    if (!todo) {
        return res.status(404).json({ error: "Todo not found" });
    }
    todo.done = !todo.done;
    res.json(todo);
});

// Delete a todo
app.delete("/todos/:id", (req, res) => {
    const { id } = req.params;
    todos = todos.filter(t => t.id !== parseInt(id));
    res.status(204).send();
});

// Start server
const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
