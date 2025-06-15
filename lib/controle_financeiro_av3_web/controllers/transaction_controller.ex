defmodule ControleFinanceiroAv3Web.TransactionController do
  use ControleFinanceiroAv3Web, :controller
  alias ControleFinanceiroAv3.Repo
  alias ControleFinanceiroAv3.Transaction
  import Ecto.Query

  def index(conn, _params) do
    current_user_id = conn.assigns.current_user_id

    transactions =
      Transaction
      |> where([t], t.user_id == ^current_user_id)
      |> Repo.all()
      |> Repo.preload([:user, :tags])

    render(conn, "index.json", transactions: transactions)
  end

  def create(conn, %{"transaction" => transaction_params}) do
    current_user_id = conn.assigns.current_user_id
    params_with_user = Map.put(transaction_params, "user_id", current_user_id)

    changeset = Transaction.changeset(%Transaction{}, params_with_user)

    case Repo.insert(changeset) do
      {:ok, transaction} ->
        transaction = Repo.preload(transaction, [:user, :tags])

        conn
        |> put_status(:created)
        |> render("show.json", transaction: transaction)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    current_user_id = conn.assigns.current_user_id

    case Repo.get_by(Transaction, id: id, user_id: current_user_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Transaction not found"})

      transaction ->
        transaction = Repo.preload(transaction, [:user, :tags])
        render(conn, "show.json", transaction: transaction)
    end
  end

  def update(conn, %{"id" => id, "transaction" => transaction_params}) do
    current_user_id = conn.assigns.current_user_id

    case Repo.get_by(Transaction |> preload(:tags), id: id, user_id: current_user_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Transaction not found"})

      transaction ->
        changeset = Transaction.changeset(transaction, transaction_params)

        case Repo.update(changeset) do
          {:ok, transaction} ->
            transaction = Repo.preload(transaction, [:user, :tags])
            render(conn, "show.json", transaction: transaction)

          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render("errors.json", changeset: changeset)
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user_id = conn.assigns.current_user_id

    case Repo.get_by(Transaction, id: id, user_id: current_user_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Transaction not found"})

      transaction ->
        case Repo.delete(transaction) do
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
