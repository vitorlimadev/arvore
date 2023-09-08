defmodule ArvoreWeb.Resolvers.Entity do
  alias Arvore.Entities

  def create_entity(_parent, params, _resolution) do
    Arvore.Entities.create_entity(params)
  end

  def fetch_entity(_parent, %{id: id}, _resolution) do
    Arvore.Entities.fetch_entity(id)
  end

  def update_entity(_parent, params, _resolution) do
    with {:ok, entity} <- Entities.fetch_entity(params.id) do
      Arvore.Entities.update_entity(entity, params)
    end
  end
end
