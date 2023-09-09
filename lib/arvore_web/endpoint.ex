defmodule ArvoreWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :arvore

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug ArvoreWeb.Router
end
