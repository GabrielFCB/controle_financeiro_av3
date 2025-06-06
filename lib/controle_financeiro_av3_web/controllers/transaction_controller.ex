defmodule ControleFinanceiroAv3Web.TransactionController do
  use ControleFinanceiroAv3Web, :controller

  def index(conn, _params) do
    json(conn, %{message: "Transactions endpoint"})
  end

  # Adicionaremos outras actions depois
end
