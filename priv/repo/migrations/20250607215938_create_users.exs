defmodule ControleFinanceiroAv3.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :nome, :string, null: false
      add :email, :string, null: false
      add :senha_hash, :string, null: false
      add :data_criacao, :naive_datetime, default: fragment("NOW()")
      add :data_atualizacao, :naive_datetime, default: fragment("NOW()")

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
