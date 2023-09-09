defmodule Arvore.Entities.Entity.Validators do
  @moduledoc "Validation functions for Entity changesets."

  alias Arvore.Entities

  def validate_parent_existance(changeset) do
    Ecto.Changeset.validate_change(changeset, :parent_id, fn
      _field, nil ->
        []

      _field, parent_id ->
        if Entities.exists?(parent_id) do
          []
        else
          [{:parent_id, "Parent not found."}]
        end
    end)
  end

  def validate_parent_cohesion(changeset) when changeset.valid? == true do
    Ecto.Changeset.validate_change(changeset, :parent_id, fn
      _field, nil ->
        []

      _field, parent_id ->
        entity_type = Ecto.Changeset.get_field(changeset, :entity_type)

        ensure_parent_cohesion(parent_id, entity_type)
    end)
  end

  # Changeset will be invalid already if parent existance validation fails.
  def validate_parent_cohesion(changeset), do: changeset

  defp ensure_parent_cohesion(_parent_id, :network),
    do: [{:parent_id, "Networks can't have parent entities."}]

  defp ensure_parent_cohesion(parent_id, :school) do
    case Entities.fetch_entity(parent_id) do
      {:ok, %{entity_type: :network}} ->
        []

      {:ok, %{entity_type: _}} ->
        [{:parent_id, "Schools can only be children of networks."}]
    end
  end

  defp ensure_parent_cohesion(parent_id, :class) do
    case Entities.fetch_entity(parent_id) do
      {:ok, %{entity_type: :school}} ->
        []

      {:ok, %{entity_type: _}} ->
        [{:parent_id, "Classes can only be children of schools."}]
    end
  end
end
