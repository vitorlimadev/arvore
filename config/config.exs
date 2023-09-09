import Config

config :arvore,
  ecto_repos: [Arvore.Repo]

config :arvore, ArvoreWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: ArvoreWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Arvore.PubSub,
  live_view: [signing_salt: "7Jfjdq4p"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
