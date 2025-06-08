defmodule ControleFinanceiroAv3.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :descricao, :string
    field :valor, :decimal
    field :tipo, :string
    field :data, :naive_datetime
    belongs_to :user, ControleFinanceiroAv3.User

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:descricao, :valor, :tipo, :data, :user_id])
    |> validate_required([:descricao, :valor, :tipo, :data, :user_id])
    |> validate_inclusion(:tipo, ["RECEITA", "DESPESA"])
    |> foreign_key_constraint(:user_id)
  end
end
