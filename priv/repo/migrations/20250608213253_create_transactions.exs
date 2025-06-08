defmodule ControleFinanceiroAv3.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :descricao, :string, null: false
      add :valor, :decimal, null: false
      add :tipo, :string, null: false
      add :data, :naive_datetime, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:transactions, [:user_id])
  end
end
