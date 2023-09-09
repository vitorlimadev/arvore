defmodule ArvoreWeb.Schema do
  @moduledoc false

  use Absinthe.Schema
  alias ArvoreWeb.Resolvers

  import_types(ArvoreWeb.Schema.Entities)

  query do
    @desc "Fetches an Entity"
    field :get_entity, :entity do
      arg(:id, non_null(:integer))

      resolve(&Resolvers.Entity.fetch_entity/3)
    end
  end

  mutation do
    @desc "Creates an Entity"
    field :create_entity, :entity do
      arg(:name, non_null(:string))
      arg(:entity_type, non_null(:string))
      arg(:parent_id, :integer)
      arg(:inep, :string)

      resolve(&Resolvers.Entity.create_entity/3)
    end

    @desc "Updates an Entity"
    field :update_entity, :entity do
      arg(:id, non_null(:integer))
      arg(:name, :string)
      arg(:entity_type, :string)
      arg(:parent_id, :integer)
      arg(:inep, :string)

      resolve(&Resolvers.Entity.update_entity/3)
    end
  end
end
