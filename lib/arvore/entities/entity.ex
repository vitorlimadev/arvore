defmodule Arvore.Entities.Entity do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @required [:name, :entity_type]
  @optional [:inep, :parent_id, :subtree_ids]

  schema "entities" do
    field :name, :string
    field :entity_type, :string
    field :inep, :string
    field :parent_id, :integer
    field :subtree_ids, {:array, :integer}, virtual: true

    timestamps()
  end

  @doc false
  def changeset(entity, attrs) do
    entity
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> unique_constraint([:name, :entity_type])
  end
end
