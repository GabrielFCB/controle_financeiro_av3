defmodule ControleFinanceiroAv3.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :nome, :string
    field :email, :string
    field :senha, :string, virtual: true # Campo virtual (não persiste no BD)
    field :senha_hash, :string
    field :data_criacao, :naive_datetime
    field :data_atualizacao, :naive_datetime
    has_many :transactions, ControleFinanceiroAv3.Transaction

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:nome, :email, :senha])
    |> validate_required([:nome, :email, :senha])
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:senha, min: 6)
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{senha: senha}} = changeset) do
    # Hash temporário - será substituído por Bcrypt depois
    change(changeset, senha_hash: "plain_#{senha}")
  end
  defp put_pass_hash(changeset), do: changeset
end
