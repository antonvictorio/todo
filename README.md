# TODO API

Local Environment Setup
```
mix deps.get
mix ecto.setup
mix phx.server
```

### Public Routes
---
**Create User**

- **POST** `http://localhost:4000/api/users`

request body
```
{
    "username": "test_todo",
    "password": "Password123"
}
```

response body
```
{
    "message": "User successfully created!"
}
```

---

**Sign In**

- **POST** `http://localhost:4000/api/users/sign_in`

request body
```
{
    "username": "test_todo",
    "password": "Password123"
}
```

response body
```
{
   "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.e..."
}
```
---

### Authenticated Routes
- All endpoints requires an auth token that will be fetched from the Sign In API:
    - **Authorization: Bearer {JWT_TOKEN}**

**Create Task**

- **POST** `http://localhost:4000/api/tasks`

request body
```
{
    "username": "test_todo",
    "password": "Password123"
}
```

response body
```
{
   "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.e..."
}
```

---

**Update Task**

- **PUT** `http://localhost:4000/api/tasks/:task_id`

- *task_id is required*

request body
```
{
    "description": "test update task"
}
```

response body
```
{
    "description": "test update task",
    "position": 1,
    "user_id": 1
}
```

---

**Get a Task**

- **GET** `http://localhost:4000/api/tasks/:task_id`
- *task_id is required*

response body
```
{
    "description": "test description",
    "position": 1,
    "user_id": 1
}
```

---

**List Tasks**

- **GET** `http://localhost:4000/api/tasks`

response body
```
{
    "tasks": [
        {
            "description": "task 1",
            "position": 1
        },
        {
            "description": "task 2",
            "position": 2
        },
        {
            "description": "task 3",
            "position": 3
        }
    ]
}
```

---

**Delete Task**

- **DELETE** `http://localhost:4000/api/tasks/:task_id`
- *task_id is required*

response body
```
{
    "message": "Successfully deleted task ID: 1"
}
```