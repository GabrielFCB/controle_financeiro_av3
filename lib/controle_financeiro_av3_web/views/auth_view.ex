defmodule ControleFinanceiroAv3Web.AuthView do
  use ControleFinanceiroAv3Web, :view

  def render("login.json", %{token: token, user: user}) do
    %{
      token: token,
      user_id: user.id,
      email: user.email,
      expires_in: 3600
    }
  end

  def render("error.json", %{message: message}) do
    %{error: message}
  end
end
