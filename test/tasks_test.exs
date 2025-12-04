defmodule Todo.TasksTest do
  use Todo.DataCase, async: true
  import Todo.Factory

  alias Todo.Tasks

  describe "get_task/1" do
    test "user gets a task" do
      user = insert!(:user)
      inserted_task = insert!(:task, %{
        user: user,
        description: "test description"
      })

      task = Tasks.get_task(inserted_task.id, inserted_task.user_id)
      assert task.id == inserted_task.id
      assert task.description == inserted_task.description
    end

    test "user should not be able to get task of another user" do
      user = insert!(:user)
      inserted_task = insert!(:task, %{
        user: user,
        description: "test description"
      })

      another_user = insert!(:user, %{
        id: 2,
        username: "user2"
      })

      assert nil === Tasks.get_task(inserted_task.id, another_user.id)
    end
  end
end
