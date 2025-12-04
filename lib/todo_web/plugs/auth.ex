defmodule TodoWeb.Plugs.Auth do
  import Plug.Conn
  alias TodoWeb.Auth

  def init(opts), do: opts

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, claims} <- Auth.verify_and_validate(token) do

      assign(conn, :current_user_id, claims["user_id"])
    else
      _ ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(:unauthorized, Jason.encode!(%{message: "Unauthorized"}))
        |> halt()
    end
  end
end
