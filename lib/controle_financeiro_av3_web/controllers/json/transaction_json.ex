defmodule ControleFinanceiroAv3Web.TransactionJSON do
  def index(%{transactions: transactions}) do
    %{data: Enum.map(transactions, &transaction_data/1)}
  end

  def show(%{transaction: transaction}) do
    %{data: transaction_data(transaction)}
  end

  defp transaction_data(transaction) do
    %{
      id: transaction.id,
      descricao: transaction.descricao,
      valor: transaction.valor,
      tipo: transaction.tipo,
      data: transaction.data,
      user_id: transaction.user_id
    }
  end

  def errors(%{changeset: changeset}) do
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
