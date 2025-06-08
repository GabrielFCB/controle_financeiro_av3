defmodule ControleFinanceiroAv3Web.UserJSON do
  def index(%{users: users}) do
    %{data: Enum.map(users, &user_data/1)}
  end

  def show(%{user: user}) do
    %{data: user_data(user)}
  end

  defp user_data(user) do
    %{
      id: user.id,
      nome: user.nome,
      email: user.email,
      data_criacao: user.data_criacao,
      data_atualizacao: user.data_atualizacao
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
