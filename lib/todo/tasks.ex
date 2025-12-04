defmodule Todo.Tasks do
  alias Todo.Repo

  alias Todo.Tasks.Task
  import Ecto.Query

  @spec get_task(integer(), integer()) :: %Task{} | nil
  def get_task(task_id, user_id) do
    Repo.get_by(Task, [id: task_id, user_id: user_id])
  end

  @spec list_tasks(String.t(), :asc | :desc) :: [%Task{}]
  def list_tasks(user_id, sort_direction \\ :asc) do
    Task
    |> select([t], %{
      id: t.id,
      description: t.description,
      position: t.position
    })
    |> where([t], t.user_id == ^user_id)
    |> order_by({^sort_direction, :position})
    |> Repo.all()
  end

  @spec create_task(integer(), map()) :: {:ok, %Task{}} | {:error, %Ecto.Changeset{}}
  def create_task(user_id, params) do
    position =
      user_id
      |> get_latest_task_position()
      |> case do
        nil -> 1.0
        latest_position -> latest_position + 1.0
      end

    %Task{}
    |> Task.changeset(Map.merge(params, %{
      "user_id" => user_id,
      "position" => position
    }))
    |> Repo.insert()
  end

  @spec get_latest_task_position(integer()) :: nil | float()
  def get_latest_task_position(user_id) do
    Task
    |> where(user_id: ^user_id)
    |> select([t], max(t.position))
    |> Repo.one()
  end

  @spec update_task(%Task{}, map()) :: {:ok, %Task{}} | {:error, %Ecto.Changeset{}}
  def update_task(task, params) do
    task
    |> Task.changeset(params)
    |> Repo.update()
  end

  @spec delete_task(%Task{}) :: {:ok, %Task{}} | {:error, %Ecto.Changeset{}}
  def delete_task(task), do: Repo.delete(task)

  @spec reposition_task(%Task{}, float(), float()) :: {:ok, %Task{}} | {:error, %Ecto.Changeset{}}
  def reposition_task(task, prev_pos, next_pos) do
    new_position =
      cond do
        prev_pos && next_pos -> (prev_pos + next_pos) / 2
        prev_pos && is_nil(next_pos) -> prev_pos + 1.0
        is_nil(prev_pos) && next_pos -> next_pos / 2
        true -> task.position
      end

    update_task(task, %{position: new_position})
  end
end
