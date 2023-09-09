defmodule ArvoreWeb.Router do
  @moduledoc false

  use ArvoreWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api" do
    pipe_through :api

    forward "/graphql", Absinthe.Plug.GraphiQL, schema: ArvoreWeb.Schema
    forward "/", Absinthe.Plug, schema: ArvoreWeb.Schema
  end
end
