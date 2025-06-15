defmodule ControleFinanceiroAv3.Transaction do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]
  alias __MODULE__
  alias ControleFinanceiroAv3.{Repo, Tag}

  schema "transactions" do
    field :descricao, :string
    field :valor, :decimal
    field :tipo, :string
    field :data, :naive_datetime
    belongs_to :user, ControleFinanceiroAv3.User

    many_to_many :tags, ControleFinanceiroAv3.Tag,
      join_through: "transactions_tags",
      on_replace: :delete

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
      nil ->
        changeset

      tag_ids when is_list(tag_ids) ->
        current_user_id = get_field(changeset, :user_id)

        # Busca tags verificando o user_id diretamente na query
        tags =
          Repo.all(
            from(t in Tag,
              where: t.id in ^tag_ids,
              where: t.user_id == ^current_user_id
            )
          )

        # Verifica se todas as tags solicitadas foram encontradas
        if length(tags) == length(Enum.uniq(tag_ids)) do
          put_assoc(changeset, :tags, tags)
        else
          add_error(changeset, :tag_ids, "contém tags inválidas ou de outro usuário")
        end

      _ ->
        add_error(changeset, :tag_ids, "deve ser uma lista de IDs")
    end
  end
end
