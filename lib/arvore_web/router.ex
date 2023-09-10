defmodule ArvoreWeb.Router do
  @moduledoc false

  use ArvoreWeb, :router

  pipeline :api do
    plug ArvoreWeb.Authentication
  end

  scope "/api" do
    pipe_through :api

    forward "/", Absinthe.Plug, schema: ArvoreWeb.Schema
  end

  if Mix.env() == :dev do
    forward "/graphql", Absinthe.Plug.GraphiQL, schema: ArvoreWeb.Schema
  end
end
