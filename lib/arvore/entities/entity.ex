defmodule Arvore.Entities.Entity do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  import Arvore.Entities.Entity.Validators

  @required [:name, :entity_type]
  @optional [:inep, :parent_id, :subtree_ids]

  schema "entities" do
    field :name, :string
    field :entity_type, Ecto.Enum, values: [:network, :school, :class]
    field :inep, :string
    field :parent_id, :integer
    field :subtree_ids, {:array, :integer}, virtual: true, default: []

    timestamps()
  end

  @doc false
  def changeset(entity, attrs) do
    entity
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
    |> validate_parent_existance()
    |> validate_parent_cohesion()
    |> unique_constraint([:name, :entity_type])
  end
end
