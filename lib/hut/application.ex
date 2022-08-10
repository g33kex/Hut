defmodule Hut.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # Migrate database
    Hut.Release.migrate()

    children = [
      # Start the Ecto repository
      Hut.Repo,
      # Start the Telemetry supervisor
      HutWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Hut.PubSub},
      # Start the Endpoint (http/https)
      HutWeb.Endpoint
      # Start a worker by calling: Hut.Worker.start_link(arg)
      # {Hut.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Hut.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HutWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
