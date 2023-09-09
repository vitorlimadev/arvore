import Config

config :arvore, Arvore.Repo,
  username: "root",
  password: "root",
  hostname: "localhost",
  database: "arvore_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :arvore, ArvoreWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "qrpkRS0PWVEwtPnj1/3PpDejQmc7yGOdV6eok/SGLCOlZ0Xpd/DYbYF6XC0HaD0i",
  watchers: [],
  api_key: "test_key"

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime
