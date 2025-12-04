defmodule TodoWeb.TaskController do
  use TodoWeb, :controller

  alias Todo.Tasks
  alias Todo.Tasks.Task

  def list_tasks(conn, _params) do
    user_id = conn.assigns.current_user_id
    tasks = Tasks.list_tasks(user_id)

    conn
    |> put_status(:ok)
    |> json(%{tasks: tasks})
  end

  def create_task(conn, params) do
    user_id = conn.assigns.current_user_id

    case Tasks.create_task(user_id, params) do
      {:ok, task} ->
        conn
        |> put_status(:ok)
        |> json(task)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(TodoWeb.ErrorView)
        |> render("changeset_error.json", changeset: changeset)
    end
  end

  def update_task(conn, %{"id" => task_id} = params) do
    user_id = conn.assigns.current_user_id

    with %Task{} = task <- Tasks.get_task(task_id, user_id),
         {:ok, task} <- Tasks.update_task(task, params)
    do
      conn
      |> put_status(:ok)
      |> json(%{message: "Successfully updated task ID: #{task.id}"})
    else
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "Task not found"})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(TodoWeb.ErrorView)
        |> render("changeset_error.json", changeset: changeset)
    end
  end

  def delete_task(conn, %{"id" => task_id}) do
    user_id = conn.assigns.current_user_id

    with {task_id, ""} <- Integer.parse(task_id),
         %Task{} = task <- Tasks.get_task(task_id, user_id),
         {:ok, task} <- Tasks.delete_task(task)
    do
      conn
      |> put_status(:ok)
      |> json(%{message: "Successfully deleted task ID: #{task.id}"})
    else
      :error ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{message: "Task ID is invalid"})

      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "Task not found"})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(TodoWeb.ErrorView)
        |> render("changeset_error.json", changeset: changeset)
    end
  end

  def get_task(conn, %{"id" => task_id}) do
    user_id = conn.assigns.current_user_id

    case Tasks.get_task(task_id, user_id) do
      %Task{} = task ->
        conn
        |> put_status(:ok)
        |> json(task)

      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "Task not found"})
    end
  end

  def reposition_task(conn, %{"id" => task_id, "previous_task_position" => pt, "next_task_position" => nt}) do
    user_id = conn.assigns.current_user_id

    with {task_id, ""} <- Integer.parse(task_id),
         %Task{} = task <- Tasks.get_task(task_id, user_id),
         {:ok, task} <- Tasks.reposition_task(task, pt, nt)
    do
      conn
      |> put_status(:ok)
      |> json(%{message: "Successfully repositioned task ID: #{task.id}"})
    else
      :error ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{message: "Task ID is invalid"})

      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{message: "Task not found"})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(TodoWeb.ErrorView)
        |> render("changeset_error.json", changeset: changeset)
    end
  end
end
