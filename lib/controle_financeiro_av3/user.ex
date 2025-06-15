defmodule ControleFinanceiroAv3.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :nome, :string
    field :email, :string
    field :senha, :string, virtual: true
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
    |> put_date_fields()
    |> put_pass_hash()
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{senha: senha}} = changeset) do
    put_change(changeset, :senha_hash, Pbkdf2.hash_pwd_salt(senha))
  end

  defp put_pass_hash(changeset), do: changeset

  defp put_date_fields(changeset) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    changeset
    |> put_change(:data_criacao, now)
    |> put_change(:data_atualizacao, now)
  end
end
