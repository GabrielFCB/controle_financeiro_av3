defmodule ControleFinanceiroAv3.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags" do
    field :nome, :string
    belongs_to :user, ControleFinanceiroAv3.User
    many_to_many :transactions, ControleFinanceiroAv3.Transaction, join_through: "transactions_tags"

    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:nome, :user_id])
    |> validate_required([:nome, :user_id])
    |> unique_constraint([:nome, :user_id], name: :tag_nome_user_index)
    |> foreign_key_constraint(:user_id)
  end
end
