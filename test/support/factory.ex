defmodule Todo.Factory do
  alias Todo.Repo

  def build(:user) do
    %Todo.Users.User{
      id: 1,
      username: "test_user",
      password_hash: Bcrypt.hash_pwd_salt("test_password")
    }
  end

  def build(:task) do
    %Todo.Tasks.Task{
      id: 1,
      user: build(:user),
      description: "test task",
      position: 1.0
    }
  end

  # Convenience API

  def build(factory_name, attributes) do
    factory_name |> build() |> struct!(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end
end
