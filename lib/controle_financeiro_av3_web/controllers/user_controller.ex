defmodule ControleFinanceiroAv3Web.UserController do
  use ControleFinanceiroAv3Web, :controller
  alias ControleFinanceiroAv3.Repo
  alias ControleFinanceiroAv3.User

  # Ação pública - não requer autenticação
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

  # Ações abaixo são privadas - requerem autenticação
  def index(conn, _params) do
    current_user_id = conn.assigns.current_user_id
    users = Repo.all(User)  # ATENÇÃO: Isso retorna todos os usuários - considere se é desejado
    render(conn, "index.json", users: users)
  end

  def show(conn, %{"id" => id}) do
    current_user_id = conn.assigns.current_user_id

    case Repo.get(User, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})

      user ->
        # Verifica se o usuário autenticado está acessando seu próprio perfil
        if user.id == current_user_id do
          render(conn, "show.json", user: user)
        else
          conn
          |> put_status(:forbidden)
          |> json(%{error: "You can only access your own profile"})
        end
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    current_user_id = conn.assigns.current_user_id

    case Repo.get(User, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})

      user ->
        # Verifica se o usuário autenticado está atualizando seu próprio perfil
        if user.id == current_user_id do
          changeset = User.changeset(user, user_params)

          case Repo.update(changeset) do
            {:ok, user} ->
              render(conn, "show.json", user: user)

            {:error, changeset} ->
              conn
              |> put_status(:unprocessable_entity)
              |> render("errors.json", changeset: changeset)
          end
        else
          conn
          |> put_status(:forbidden)
          |> json(%{error: "You can only update your own profile"})
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user_id = conn.assigns.current_user_id

    case Repo.get(User, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})

      user ->
        # Verifica se o usuário autenticado está deletando seu próprio perfil
        if user.id == current_user_id do
          case Repo.delete(user) do
            {:ok, _} ->
              send_resp(conn, :no_content, "")

            {:error, changeset} ->
              conn
              |> put_status(:unprocessable_entity)
              |> render("errors.json", changeset: changeset)
          end
        else
          conn
          |> put_status(:forbidden)
          |> json(%{error: "You can only delete your own profile"})
        end
    end
  end
end
