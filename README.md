# TODO API

**Local Environment Setup**
```elixir
mix deps.get;
mix ecto.setup;
mix phx.server;
```

**Sample PostgreSQL script to seed 1 millions tasks**
```sql
INSERT INTO tasks (description, position, user_id, inserted_at, updated_at)
SELECT
  'task ' || gs,
  gs * 1.0,
  1,
  NOW(),
  NOW()
FROM generate_series(1, 1000000) AS gs;
```

**Testing of list tasks API with 1m rows**
- tested on a local environment using a Macbook Air M1 (8gb RAM) via Postman collections
    - user has 1m tasks
    - iterations: 20
    - average response time: 3847ms

<img src="https://github.com/antonvictorio/todo/blob/master/TEST_20.png" width="1024px">


### Public Routes
---
**Create User**

- **POST**
```
http://localhost:4000/api/users
```

request body
```json
{
    "username": "test_todo",
    "password": "Password123"
}
```

response body
```json
{
    "message": "User successfully created!"
}
```

---

**Sign In**

- **POST**
```
http://localhost:4000/api/users/sign_in
```

request body
```json
{
    "username": "test_todo",
    "password": "Password123"
}
```

response body
```json
{
   "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.e..."
}
```
---

### Authenticated Routes
- All endpoints requires an auth token that will be fetched from the Sign In API:
    - **Authorization: Bearer *{JWT_TOKEN}***

**Create Task**

- **POST**
```
http://localhost:4000/api/tasks
```

request body
```json
{
    "description": "test update task"
}
```

response body
```json
{
   "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.e..."
}
```

---

**Update Task**

- **PUT** (*task_id is required*)
```
http://localhost:4000/api/tasks/:task_id
```

request body
```json
{
    "description": "test update task"
}
```

response body
```json
{
    "message": "Successfully updated task ID: 1"
}
```

---

**Get a Task**

- **GET** (*task_id is required*)

```text
http://localhost:4000/api/tasks/:task_id
```

response body
```json
{
    "description": "test description",
    "position": 1.0,
    "user_id": 1
}
```

---

**List Tasks**

- **GET**
```
http://localhost:4000/api/tasks
```

response body
```json
{
    "tasks": [
        {
            "id": 1,
            "description": "task 1",
            "position": 1.0
        },
        {
            "id": 2,
            "description": "task 2",
            "position": 2.0
        },
        {
            "id": 3,
            "description": "task 3",
            "position": 3.0
        }
    ]
}
```

---

**Delete Task**

- **DELETE** (*task_id is required*)
```text
http://localhost:4000/api/tasks/:task_id
```

response body
```json
{
    "message": "Successfully deleted task ID: 1"
}
```

---

**Reposition Task**

- **PUT** (*task_id is required*)
```
http://localhost:4000/api/tasks/:task_id/reposition
```

request body
```json
{
    "previous_task": 1.0,
    "next_task": 2.0
}
```

response body
```json
{
    "message": "Successfully repositioned task ID: 3"
}
```
