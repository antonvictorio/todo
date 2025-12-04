defmodule Todo.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :password_hash, :string

    field :password, :string, virtual: true
    timestamps()
  end

  @attrs [:username, :password]

  def changeset(user, params) do
    user
    |> cast(params, @attrs)
    |> validate_required(@attrs)
    |> unique_constraint([:username])
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: pw}} = changeset) do
    Ecto.Changeset.change(
      changeset,
      password_hash: Bcrypt.hash_pwd_salt(pw)
    )
  end

  defp put_password_hash(changeset), do: changeset
end
