defmodule ControleFinanceiroAv3Web.TagController do
  use ControleFinanceiroAv3Web, :controller
  alias ControleFinanceiroAv3.Repo
  alias ControleFinanceiroAv3.Tag
  import Ecto.Query

  # GET /api/tags
  def index(conn, _params) do
    current_user_id = conn.assigns.current_user_id

    tags =
      Tag
      |> where([t], t.user_id == ^current_user_id)
      |> Repo.all()

    render(conn, "index.json", tags: tags)
  end

  # POST /api/tags
  def create(conn, %{"tag" => tag_params}) do
    current_user_id = conn.assigns.current_user_id
    params_with_user = Map.put(tag_params, "user_id", current_user_id)

    changeset = Tag.changeset(%Tag{}, params_with_user)

    case Repo.insert(changeset) do
      {:ok, tag} ->
        conn
        |> put_status(:created)
        |> render("show.json", tag: tag)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json", changeset: changeset)
    end
  end

  # GET /api/tags/:id
  def show(conn, %{"id" => id}) do
    current_user_id = conn.assigns.current_user_id

    case Repo.get_by(Tag, id: id, user_id: current_user_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Tag not found"})

      tag ->
        render(conn, "show.json", tag: tag)
    end
  end

  # PUT /api/tags/:id
  def update(conn, %{"id" => id, "tag" => tag_params}) do
    current_user_id = conn.assigns.current_user_id

    case Repo.get_by(Tag, id: id, user_id: current_user_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Tag not found"})

      tag ->
        changeset = Tag.changeset(tag, tag_params)

        case Repo.update(changeset) do
          {:ok, tag} ->
            render(conn, "show.json", tag: tag)

          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render("errors.json", changeset: changeset)
        end
    end
  end

  # DELETE /api/tags/:id
  def delete(conn, %{"id" => id}) do
    current_user_id = conn.assigns.current_user_id

    case Repo.get_by(Tag, id: id, user_id: current_user_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Tag not found"})

      tag ->
        case Repo.delete(tag) do
          {:ok, _} ->
            send_resp(conn, :no_content, "")

          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render("errors.json", changeset: changeset)
        end
    end
  end
end
