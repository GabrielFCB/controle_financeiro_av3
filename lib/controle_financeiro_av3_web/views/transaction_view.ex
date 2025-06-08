defmodule ControleFinanceiroAv3Web.TransactionView do
  use ControleFinanceiroAv3Web, :view

  def render("index.json", %{transactions: transactions}) do
    %{data: render_many(transactions, __MODULE__, "transaction.json")}
  end

  def render("show.json", %{transaction: transaction}) do
    %{data: render_one(transaction, __MODULE__, "transaction.json")}
  end

  def render("transaction.json", %{transaction: transaction}) do
    %{
      id: transaction.id,
      descricao: transaction.descricao,
      valor: transaction.valor,
      tipo: transaction.tipo,
      data: transaction.data,
      user_id: transaction.user_id,
      data_criacao: transaction.inserted_at,
      data_atualizacao: transaction.updated_at
    }
  end

  def render("errors.json", %{changeset: changeset}) do
    %{errors: translate_errors(changeset)}
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
