defmodule Todo.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :description, :text
      add :position, :float, null: false

      timestamps()
    end

    create index(:tasks, [:user_id])
    create index(:tasks, [:user_id, :position])
  end
end
