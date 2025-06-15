defmodule ControleFinanceiroAv3Web.TagJSON do
  def index(%{tags: tags}) do
    %{data: Enum.map(tags, &tag_data/1)}
  end

  def show(%{tag: tag}) do
    %{data: tag_data(tag)}
  end

  defp tag_data(tag) do
    %{
      id: tag.id,
      nome: tag.nome
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
