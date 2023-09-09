defmodule ArvoreWeb.Authentication do
  @moduledoc """
  API key authentication Plug.

  Do not disable SSL in production to ensure the client's API keys are encrypted on requests.
  """

  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    with [received_api_key] <- get_req_header(conn, "x-api-key"),
         real_api_key <- Application.get_env(:arvore, ArvoreWeb.Endpoint)[:api_key],
         true <- received_api_key == real_api_key do
      conn
    else
      _ -> unauthorize(conn)
    end
  end

  defp unauthorize(conn) do
    conn
    |> halt()
    |> send_resp(401, "Unauthorized")
  end
end
