defmodule ControleFinanceiroAv3Web.Plugs.Auth do
  import Plug.Conn
  alias ControleFinanceiroAv3Web.Auth

  def init(default), do: default

  def call(conn, _default) do
    case extract_token(conn) do
      {:ok, token} ->
        verify_token(conn, token)

      :error ->
        auth_error(conn)
    end
  end

  defp extract_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> {:ok, token}
      _ -> :error
    end
  end

  defp verify_token(conn, token) do
    case Auth.verify_token(token) do
      {:ok, claims} ->
        assign(conn, :current_user_id, claims["user_id"])

      {:error, _reason} ->
        auth_error(conn)
    end
  end

  defp auth_error(conn) do
    conn
    |> put_status(:unauthorized)
    |> Phoenix.Controller.render(ControleFinanceiroAv3Web.ErrorView, :"401")
    |> halt()
  end
end
