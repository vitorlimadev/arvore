defmodule ArvoreWeb.Resolvers.Entity do
  alias Arvore.Entities

  def fetch_entity(_parent, %{id: id}, _resolution) do
    Arvore.Entities.fetch_entity(id)
  end

  def create_entity(_parent, params, _resolution) do
    params
    |> Arvore.Entities.create_entity()
    |> parse_result()
  end

  def update_entity(_parent, params, _resolution) do
    with {:ok, entity} <- Entities.fetch_entity(params.id) do
      entity
      |> Arvore.Entities.update_entity(params)
      |> parse_result()
    end
  end

  defp parse_result({:error, %Ecto.Changeset{valid?: false} = changeset}) do
    {:error, "#{inspect(changeset.errors)}"}
  end

  defp parse_result(result), do: result
end
