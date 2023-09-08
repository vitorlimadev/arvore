defmodule Arvore.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ArvoreWeb.Telemetry,
      Arvore.Repo,
      {Phoenix.PubSub, name: Arvore.PubSub},
      ArvoreWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Arvore.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    ArvoreWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
