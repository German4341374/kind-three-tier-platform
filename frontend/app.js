const form = document.querySelector("#task-form");
const title = document.querySelector("#title");
const list = document.querySelector("#tasks");
const status = document.querySelector("#status");

async function loadTasks() {
  const response = await fetch("/api/tasks");
  if (!response.ok) throw new Error("API request failed");
  const tasks = await response.json();
  list.replaceChildren(...tasks.map((task) => {
    const item = document.createElement("li");
    item.textContent = task.title;
    return item;
  }));
}

form.addEventListener("submit", async (event) => {
  event.preventDefault();
  status.textContent = "Saving...";
  try {
    const response = await fetch("/api/tasks", {
      method: "POST",
      headers: {"Content-Type": "application/json"},
      body: JSON.stringify({title: title.value}),
    });
    if (!response.ok) throw new Error("Task creation failed");
    title.value = "";
    await loadTasks();
    status.textContent = "Task saved.";
  } catch (error) {
    status.textContent = error.message;
  }
});

loadTasks().catch((error) => { status.textContent = error.message; });
