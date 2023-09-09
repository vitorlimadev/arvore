defmodule Arvore.MixProject do
  use Mix.Project

  def project do
    [
      app: :arvore,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: test_coverage()
    ]
  end

  def application do
    [
      mod: {Arvore.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.7.7"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.10"},
      {:myxql, ">= 0.0.0"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      {:absinthe, "~> 1.7.0"},
      {:absinthe_plug, "~> 1.5"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_machina, "~> 2.7.0", only: :test}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end

  defp test_coverage do
    [
      ignore_modules: [
        # Auto generated/Coverage noise
        Arvore.Application,
        Arvore.DataCase,
        Arvore.Factory,
        Arvore.Release,
        Arvore.Repo,
        ArvoreWeb.ConnCase,
        ArvoreWeb.Endpoint,
        ArvoreWeb.Router,
        ArvoreWeb.Telemetry,
        # GraphQL schemas
        ArvoreWeb.Schema.Entities,
        ArvoreWeb.Schema.Compiled
      ]
    ]
  end
end
