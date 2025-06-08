defmodule ControleFinanceiroAv3Web.UserController do
  use ControleFinanceiroAv3Web, :controller
  alias ControleFinanceiroAv3.Repo
  alias ControleFinanceiroAv3.User

  # GET /api/users
  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", users: users)
  end

  # POST /api/users
  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render("show.json", user: user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json", changeset: changeset)
    end
  end

  # GET /api/users/:id
  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.json", user: user)
  end

  # PUT /api/users/:id
  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json", changeset: changeset)
    end
  end

  # DELETE /api/users/:id
  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    case Repo.delete(user) do
      {:ok, _} ->
        send_resp(conn, :no_content, "")

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json", changeset: changeset)
    end
  end
end
