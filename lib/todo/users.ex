defmodule Todo.Users do
  alias Todo.Repo
  alias Todo.Users.User

  @spec register(
    %{username: String.t(), password: String.t()}
  ) :: {:ok, %User{}} | {:error, %Ecto.Changeset{}}
  def register(params) do
    changeset = User.changeset(%User{}, params)
    Repo.insert(changeset)
  end

  @spec get_user_by_username(String.t()) :: nil | %User{}
  def get_user_by_username(username) do
    Repo.get_by(User, username: username)
  end
end
