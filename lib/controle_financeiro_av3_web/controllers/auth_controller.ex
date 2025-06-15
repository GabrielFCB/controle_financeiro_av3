defmodule ControleFinanceiroAv3Web.AuthController do
  use ControleFinanceiroAv3Web, :controller
  alias ControleFinanceiroAv3Web.Auth

  def login(conn, %{"email" => email, "senha" => senha}) do
    case Auth.authenticate(email, senha) do
      {:ok, user} ->
        {:ok, token, _claims} = Auth.generate_token(user)
        conn
        |> put_status(:ok)
        |> render("login.json", token: token)

      {:error, reason} ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json", message: error_message(reason))
    end
  end

  defp error_message(:not_found), do: "Usuário não encontrado"
  defp error_message(:invalid_credentials), do: "Credenciais inválidas"
end
