const API_URL = "/api/todos";

async function fetchTodos() {
    const response = await fetch(API_URL);
    const todos = await response.json();
    const list = document.getElementById("todoList");
    list.innerHTML = "";
    todos.forEach(todo => {
        const li = document.createElement("li");
        li.innerHTML = `
            <span style="text-decoration: ${todo.done ? 'line-through' : 'none'}">${todo.text}</span>
            <button onclick="toggleTodo(${todo.id})">${todo.done ? "Undo" : "Done"}</button>
            <button onclick="deleteTodo(${todo.id})">Delete</button>
        `;
        list.appendChild(li);
    });
}

async function addTodo() {
    const input = document.getElementById("todoInput");
    const text = input.value.trim();
    if (!text) return;
    await fetch(API_URL, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ text })
    });
    input.value = "";
    fetchTodos();
}

async function toggleTodo(id) {
    await fetch(`${API_URL}/${id}`, { method: "PATCH" });
    fetchTodos();
}

async function deleteTodo(id) {
    await fetch(`${API_URL}/${id}`, { method: "DELETE" });
    fetchTodos();
}

fetchTodos();
