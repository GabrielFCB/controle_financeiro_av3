defmodule ControleFinanceiroAv3Web.AuthJSON do
  # Renderização para login bem-sucedido
  def render("login.json", %{token: token}) do
    %{token: token}
  end

  # Renderização para erros de autenticação
  def render("error.json", %{message: message}) do
    %{error: message}
  end
end
