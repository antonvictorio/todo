defmodule Todo.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [
    :id,
    :description,
    :position,
    :user_id
  ]}

  schema "tasks" do
    field :description, :string
    field :position, :float

    belongs_to :user, Todo.Users.User

    timestamps()
  end

  @attrs [:description, :position, :user_id]

  def changeset(task, params) do
    task
    |> cast(params, @attrs)
    |> validate_required(@attrs)
  end
end
