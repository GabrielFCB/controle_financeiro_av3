defmodule ControleFinanceiroAv3.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]  # Adicione esta linha
  alias __MODULE__

  schema "transactions" do
    field :descricao, :string
    field :valor, :decimal
    field :tipo, :string
    field :data, :naive_datetime
    belongs_to :user, ControleFinanceiroAv3.User
    many_to_many :tags, ControleFinanceiroAv3.Tag, join_through: "transactions_tags"

    timestamps()
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:descricao, :valor, :tipo, :data, :user_id])
    |> validate_required([:descricao, :valor, :tipo, :data, :user_id])
    |> validate_inclusion(:tipo, ["RECEITA", "DESPESA"])
    |> foreign_key_constraint(:user_id)
    |> cast_tag_associations(attrs)
  end

  defp cast_tag_associations(changeset, attrs) do
    case Map.get(attrs, "tag_ids") do
      nil -> changeset
      tag_ids when is_list(tag_ids) ->
        # Correção: Sintaxe correta para query
        tags = ControleFinanceiroAv3.Repo.all(
          from(t in ControleFinanceiroAv3.Tag, where: t.id in ^tag_ids)
        )
        put_assoc(changeset, :tags, tags)
      _ ->
        add_error(changeset, :tag_ids, "Formato inválido")
    end
  end
end
