defmodule ControleFinanceiroAv3Web.Router do
  use ControleFinanceiroAv3Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ControleFinanceiroAv3Web.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

 pipeline :api_auth do
    plug :accepts, ["json"]
    plug ControleFinanceiroAv3Web.Plugs.Auth
  end


  scope "/api", ControleFinanceiroAv3Web do
    # Rotas PÚBLICAS (sem autenticação)
    pipe_through :api

    post "/users", UserController, :create
    post "/login", AuthController, :login

    # Rotas PRIVADAS (com autenticação)
    scope "/" do
      pipe_through :api_auth

      resources "/users", UserController, except: [:create]
      resources "/transactions", TransactionController
      resources "/tags", TagController
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", ControleFinanceiroAv3Web do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:controle_financeiro_av3, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ControleFinanceiroAv3Web.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
