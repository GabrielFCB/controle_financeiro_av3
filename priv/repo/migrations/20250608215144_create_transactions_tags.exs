defmodule ControleFinanceiroAv3.Repo.Migrations.CreateTransactionsTags do
  use Ecto.Migration

  def change do
    create table(:transactions_tags) do
      add :transaction_id, references(:transactions, on_delete: :delete_all), null: false
      add :tag_id, references(:tags, on_delete: :delete_all), null: false
    end

    create unique_index(:transactions_tags, [:transaction_id, :tag_id])
  end
end
