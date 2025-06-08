defmodule ControleFinanceiroAv3.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :nome, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:tags, [:user_id])
    create unique_index(:tags, [:nome, :user_id], name: :tag_nome_user_index)
  end
end
