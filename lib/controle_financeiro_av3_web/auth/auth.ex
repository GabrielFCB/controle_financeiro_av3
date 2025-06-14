defmodule ControleFinanceiroAv3Web.Auth do
  @moduledoc """
  Módulo responsável pela autenticação JWT
  """

  alias ControleFinanceiroAv3.Repo
  alias ControleFinanceiroAv3.User
  alias Joken.Signer

  @secret "s3cr3t_k3y"  # Em produção, use ENV var!
  @default_exp 3600 # 1 hora

  # Geração de token para usuário
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
      "exp" => nil,  # Não requer expiração por padrão
      "aud" => nil,  # Não requer audience
      "iss" => nil   # Não requer issuer
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
