import Config

if System.get_env("PHX_SERVER") do
  config :arvore, ArvoreWeb.Endpoint, server: true
end

if config_env() == :prod do
  username = System.fetch_env!("MYSQL_USERNAME")
  password = System.fetch_env!("MYSQL_PASSWORD")
  hostname = System.fetch_env!("MYSQL_HOSTNAME")
  database = System.fetch_env!("MYSQL_DATABASE")

  config :arvore, Arvore.Repo,
    ssl: true,
    username: username,
    password: password,
    hostname: hostname,
    database: database,
    stacktrace: true,
    protocol: :tcp,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: [:inet6]

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :arvore, ArvoreWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base,
    api_key: System.fetch_env!("API_KEY")

  config :arvore, ArvoreWeb.Endpoint, force_ssl: [hsts: true]
end
