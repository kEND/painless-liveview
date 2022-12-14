defmodule PainlessWeb.Router do
  use PainlessWeb, :router

  import PainlessWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PainlessWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PainlessWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", PainlessWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:painless, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PainlessWeb.Telemetry
    end

    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", PainlessWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{PainlessWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", PainlessWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{PainlessWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

      scope "/tenancies" do
        live "/", TenancyLive.Index, :index
        live "/new", TenancyLive.Index, :new
        live "/:id/edit", TenancyLive.Index, :edit

        live "/:id", TenancyLive.Show, :show
        live "/:id/show/edit", TenancyLive.Show, :edit

        scope "/:tenancy_id/ledgers" do
          live "/", LedgerLive.Index, :index
          live "/new", LedgerLive.Index, :new
          live "/:id/edit", LedgerLive.Index, :edit

          live "/:id", LedgerLive.Show, :show
          live "/:id/show/edit", LedgerLive.Show, :edit

          scope ":ledger_id/entries" do
            live "/", EntryLive.Index, :index
            live "/new", EntryLive.Index, :new
            live "/:id/edit", EntryLive.Index, :edit

            live "/:id", EntryLive.Show, :show
            live "/:id/show/edit", EntryLive.Show, :edit
          end
        end
      end
    end
  end

  scope "/", PainlessWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{PainlessWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
