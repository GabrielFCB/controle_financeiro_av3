defmodule ControleFinanceiroAv3Web.TagController do
  use ControleFinanceiroAv3Web, :controller

  def index(conn, _params) do
    json(conn, %{message: "Tags endpoint"})
  end

  # Adicionaremos outras actions depois
end
