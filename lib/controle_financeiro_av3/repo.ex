defmodule ControleFinanceiroAv3.Repo do
  use Ecto.Repo,
    otp_app: :controle_financeiro_av3,
    adapter: Ecto.Adapters.Postgres
end
