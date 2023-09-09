defmodule ArvoreWeb.Schema.Entities do
  @moduledoc false

  use Absinthe.Schema.Notation

  object :entity do
    field :id, :integer
    field :name, :string
    field :entity_type, :string
    field :inep, :string
    field :parent_id, :integer
    field :subtree_ids, list_of(:integer)
  end
end
