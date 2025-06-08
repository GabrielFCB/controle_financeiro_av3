defmodule ControleFinanceiroAv3Web.TagController do
  use ControleFinanceiroAv3Web, :controller
  alias ControleFinanceiroAv3.Repo
  alias ControleFinanceiroAv3.Tag

  # GET /api/tags
  def index(conn, _params) do
    tags = Repo.all(Tag)
    render(conn, "index.json", tags: tags)
  end

  # POST /api/tags
  def create(conn, %{"tag" => tag_params}) do
    changeset = Tag.changeset(%Tag{}, tag_params)

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
    tag = Repo.get!(Tag, id)
    render(conn, "show.json", tag: tag)
  end

  # PUT /api/tags/:id
  def update(conn, %{"id" => id, "tag" => tag_params}) do
    tag = Repo.get!(Tag, id)
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

  # DELETE /api/tags/:id
  def delete(conn, %{"id" => id}) do
    tag = Repo.get!(Tag, id)

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
