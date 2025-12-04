defmodule TodoWeb.UserController do
  use TodoWeb, :controller

  alias Todo.Users
  alias TodoWeb.Auth

  def register(conn, params) do
    case Users.register(params) do
      {:ok, _user} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "User sucessfully created!"})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(TodoWeb.ErrorView)
        |> render("changeset_error.json", changeset: changeset)
    end
  end

  def sign_in(conn, %{"username" => username, "password" => password}) do
    case Users.get_user_by_username(username) do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Username or Password is invalid"})

      user ->
        if Bcrypt.verify_pass(password, user.password_hash) do
          token = Auth.generate_token(user)
          conn
          |> json(%{token: token})
        else
          conn
          |> put_status(:unauthorized)
          |> json(%{error: "Username or Password is invalid"})
        end
    end
  end
end
