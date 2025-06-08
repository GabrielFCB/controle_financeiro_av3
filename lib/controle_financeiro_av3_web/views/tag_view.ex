defmodule ControleFinanceiroAv3Web.TagView do
  use ControleFinanceiroAv3Web, :view

  def render("index.json", %{tags: tags}) do
    %{data: render_many(tags, __MODULE__, "tag.json")}
  end

  def render("show.json", %{tag: tag}) do
    %{data: render_one(tag, __MODULE__, "tag.json")}
  end

  def render("tag.json", %{tag: tag}) do
    %{
      id: tag.id,
      nome: tag.nome,
      user_id: tag.user_id,
      data_criacao: tag.inserted_at,
      data_atualizacao: tag.updated_at
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
