defmodule ControleFinanceiroAv3Web.UserController do
  use ControleFinanceiroAv3Web, :controller

  def index(conn, _params) do
    json(conn, %{message: "Users endpoint"})
  end

  # Adicionaremos outras actions depois
end
