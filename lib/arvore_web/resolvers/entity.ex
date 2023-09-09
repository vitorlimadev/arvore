defmodule ArvoreWeb.Resolvers.Entity do
  @moduledoc false

  alias Arvore.Entities

  def fetch_entity(_parent, %{id: id}, _resolution) do
    Arvore.Entities.fetch_entity(id, fetch_children?: true)
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

  defp parse_result({:error, %Ecto.Changeset{valid?: false, errors: errors}}) do
    error_list = Enum.map(errors, fn {key, {message, _}} -> {key, message} end)

    {:error, "#{inspect(error_list)}"}
  end

  defp parse_result(result), do: result
end
