defmodule Painless.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      PainlessWeb.Telemetry,
      # Start the Ecto repository
      Painless.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Painless.PubSub},
      # Start Finch
      {Finch, name: Painless.Finch},
      # Start the Endpoint (http/https)
      PainlessWeb.Endpoint
      # Start a worker by calling: Painless.Worker.start_link(arg)
      # {Painless.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Painless.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PainlessWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
