defmodule Arvore.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ArvoreWeb.Telemetry,
      # Start the Ecto repository
      Arvore.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Arvore.PubSub},
      # Start the Endpoint (http/https)
      ArvoreWeb.Endpoint
      # Start a worker by calling: Arvore.Worker.start_link(arg)
      # {Arvore.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Arvore.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ArvoreWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
