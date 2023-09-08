defmodule ArvoreWeb.Router do
  use ArvoreWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ArvoreWeb do
    pipe_through :api
  end
end
