import Config

if System.get_env("PHX_SERVER") do
  config :arvore, ArvoreWeb.Endpoint, server: true
end

if config_env() == :prod do
  db_url = System.fetch_env!("JAWSDB_MARIA_URL")
  secret_key_base = System.fetch_env!("SECRET_KEY_BASE")
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :arvore, Arvore.Repo,
    ssl: true,
    url: db_url,
    stacktrace: true,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "5")

  config :arvore, ArvoreWeb.Endpoint,
    url: [host: "vast-island-94364-a3d3b4324b8c.herokuapp.com", port: 443, scheme: "https"],
    force_ssl: [rewrite_on: [:x_forwarded_proto]],
    http: [ip: {0, 0, 0, 0, 0, 0, 0, 0}, port: port],
    secret_key_base: secret_key_base,
    api_key: System.fetch_env!("API_KEY")
end
