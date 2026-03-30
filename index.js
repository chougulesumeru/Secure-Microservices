const express = require("express");
const mongoose = require("mongoose");

const app = express();
app.use(express.json());

mongoose.connect("mongodb://mongo:27017/todos");

const Todo = mongoose.model("Todo", { task: String });

app.get("/", (req, res) => {
  res.send("Docker Todo App Running 🚀");
});

app.post("/todo", async (req, res) => {
  const todo = new Todo({ task: req.body.task });
  await todo.save();
  res.send(todo);
});

app.get("/todos", async (req, res) => {
  const todos = await Todo.find();
  res.send(todos);
});

app.listen(3000, () => console.log("Server running on port 3000"));