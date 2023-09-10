import Config

config :arvore, Arvore.Repo,
  username: "root",
  password: "root",
  hostname: "localhost",
  database: "arvore_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :arvore, ArvoreWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "ZSd5daVFdL+AwQM3iRVrpUGRqY98VLIRnUQ1LXu/Prmmqq09ZLxM+4f+tShMN3bJ",
  server: false,
  api_key: "test_key"

config :logger, level: :warning

config :phoenix, :plug_init_mode, :runtime
