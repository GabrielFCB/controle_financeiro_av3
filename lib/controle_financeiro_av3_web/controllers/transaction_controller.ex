defmodule ControleFinanceiroAv3Web.TransactionController do
  use ControleFinanceiroAv3Web, :controller
  alias ControleFinanceiroAv3.Repo
  alias ControleFinanceiroAv3.Transaction

  # GET /api/transactions
  def index(conn, _params) do
    transactions = Repo.all(Transaction) |> Repo.preload(:user)
    render(conn, "index.json", transactions: transactions)
  end

  # POST /api/transactions
  def create(conn, %{"transaction" => transaction_params}) do
    changeset = Transaction.changeset(%Transaction{}, transaction_params)

    case Repo.insert(changeset) do
      {:ok, transaction} ->
        conn
        |> put_status(:created)
        |> render("show.json", transaction: Repo.preload(transaction, :user))

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json", changeset: changeset)
    end
  end

  # GET /api/transactions/:id
  def show(conn, %{"id" => id}) do
    transaction = Repo.get!(Transaction, id) |> Repo.preload(:user)
    render(conn, "show.json", transaction: transaction)
  end

  # PUT /api/transactions/:id
  def update(conn, %{"id" => id, "transaction" => transaction_params}) do
    transaction = Repo.get!(Transaction, id)
    changeset = Transaction.changeset(transaction, transaction_params)

    case Repo.update(changeset) do
      {:ok, transaction} ->
        render(conn, "show.json", transaction: Repo.preload(transaction, :user))

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("errors.json", changeset: changeset)
    end
  end

  # DELETE /api/transactions/:id
  def delete(conn, %{"id" => id}) do
    transaction = Repo.get!(Transaction, id)

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
