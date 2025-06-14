defmodule ControleFinanceiroAv3Web.ErrorView do
  # ... código existente ...

  # Adicione este novo caso
  def render("401.json", _assigns) do
    %{error: "Não autorizado"}
  end

  # Mantenha o fallback
  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
