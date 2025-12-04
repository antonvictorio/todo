defmodule TodoWeb.Auth do
  use Joken.Config

  def token_config, do: default_claims()

  @spec generate_token(%Todo.Users.User{}) :: String.t()
  def generate_token(user), do: TodoWeb.Auth.generate_and_sign!(%{user_id: user.id})
end
