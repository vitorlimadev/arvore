defmodule Arvore.EntitiesTest do
  use Arvore.DataCase
  import Arvore.Factory

  alias Arvore.Entities
  alias Arvore.Entities.Entity

  describe "create_entity/1" do
    test "creates and entity with valid params" do
      entity = insert(:entity, %{name: "Test 1", entity_type: "school"})

      assert {:ok,
              %Entity{
                name: "Test 1",
                entity_type: "school",
                parent_id: nil,
                subtree_ids: []
              }} = Entities.fetch_entity(entity.id)
    end
  end
end
