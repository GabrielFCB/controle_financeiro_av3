defmodule ControleFinanceiroAv3Web.Auth do
  @moduledoc """
  Módulo responsável pela autenticação JWT
  """

  alias ControleFinanceiroAv3.Repo
  alias ControleFinanceiroAv3.User
  alias Joken.Signer

  @secret "s3cr3t_k3y"
  @default_exp 3600 # 1 hora

  def generate_token(user) do
    signer = Signer.create("HS256", @secret)

    extra_claims = %{
      "user_id" => user.id,
      "exp" => System.system_time(:second) + @default_exp
    }

    Joken.generate_and_sign(%{}, extra_claims, signer)
  end

  # Verificação de token
  def verify_token(token) do
    signer = Signer.create("HS256", @secret)

    default_claims = %{
      "exp" => nil,
      "aud" => nil,
      "iss" => nil
    }

    Joken.verify_and_validate(default_claims, token, signer)
  end

  # Autenticação por email/senha
  def authenticate(email, senha) do
    case Repo.get_by(User, email: email) do
      nil ->
        {:error, :not_found}
      user ->
        if Pbkdf2.verify_pass(senha, user.senha_hash) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end
end
