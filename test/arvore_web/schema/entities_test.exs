defmodule ArvoreWeb.Schema.EntitiesTest do
  use ArvoreWeb.ConnCase, async: true
  import Arvore.Factory

  @create_entity_mutation """
    mutation CreateEntity(
      $name: String!,
      $entityType: String!,
      $inep: String,
      $parentId: Int,
    ) {
    createEntity(
      name: $name,
      entityType: $entityType, 
      inep: $inep,
      parent_id: $parentId
    ) {
      id
      name
      entity_type
      inep
      parent_id
      subtree_ids
    }
  }
  """

  describe "create_entity sucess cases" do
    test "creates an entity with valid params", %{conn: conn} do
      # EXECUTE
      conn =
        conn
        |> post("/api", %{
          "query" => @create_entity_mutation,
          "variables" => %{name: "Network 1", entityType: "network"}
        })

      # ASSERT
      assert %{
               "data" => %{
                 "createEntity" => %{
                   "id" => _,
                   "name" => "Network 1",
                   "parent_id" => nil,
                   "inep" => nil,
                   "subtree_ids" => []
                 }
               }
             } = json_response(conn, 200)
    end

    test "creates a child entity", %{conn: conn} do
      # SETUP

      # Create the parent network
      %{id: network_id} = insert(:entity, entity_type: "network")

      # EXECUTE
      conn =
        conn
        |> post("/api", %{
          "query" => @create_entity_mutation,
          "variables" => %{name: "School 1", entityType: "school", parentId: network_id}
        })

      # ASSERT
      assert %{
               "data" => %{
                 "createEntity" => %{
                   "id" => _,
                   "name" => "School 1",
                   "parent_id" => ^network_id
                 }
               }
             } = json_response(conn, 200)
    end
  end

  describe "create_entity error cases" do
    test "handles empty payload", %{conn: conn} do
      # EXECUTE
      conn =
        conn
        |> post("/api", %{
          "query" => @create_entity_mutation,
          "variables" => %{}
        })

      # ASSERT
      assert %{
               "errors" => [
                 %{
                   "message" => "In argument \"name\": Expected type \"String!\", found null."
                 },
                 %{
                   "message" =>
                     "In argument \"entityType\": Expected type \"String!\", found null."
                 }
                 | _
               ]
             } = json_response(conn, 200)
    end

    test "fails when creating a entity with a non-existing parent", %{conn: conn} do
      # EXECUTE
      conn =
        conn
        |> post("/api", %{
          "query" => @create_entity_mutation,
          "variables" => %{name: "School 1", entityType: "school", parentId: 1}
        })

      # ASSERT
      assert %{
               "errors" => [
                 %{"message" => "[parent_id: \"Parent not found.\"]"}
               ]
             } = json_response(conn, 200)
    end

    test "ensures networks have no parents", %{conn: conn} do
      # SETUP

      # Create the parent network
      %{id: network_id} = insert(:entity, entity_type: "network")

      # EXECUTE
      conn =
        conn
        |> post("/api", %{
          "query" => @create_entity_mutation,
          "variables" => %{name: "Network 1", entityType: "network", parentId: network_id}
        })

      # ASSERT
      assert %{
               "errors" => [
                 %{"message" => "[parent_id: \"Networks can't have parent entities.\"]"}
               ]
             } = json_response(conn, 200)
    end

    test "ensures schools can have only networks as parents", %{conn: conn} do
      # SETUP

      # Create the invalid parent
      %{id: invalid_parent_id} = insert(:entity, entity_type: Enum.random(["school", "class"]))

      # EXECUTE
      conn =
        conn
        |> post("/api", %{
          "query" => @create_entity_mutation,
          "variables" => %{name: "School 2", entityType: "school", parentId: invalid_parent_id}
        })

      # ASSERT
      assert %{
               "errors" => [
                 %{
                   "message" => "[parent_id: \"Schools can only be children of networks.\"]"
                 }
               ]
             } = json_response(conn, 200)
    end

    test "ensures classes can have only schools as parents", %{conn: conn} do
      # SETUP

      # Create the invalid parent
      %{id: invalid_parent_id} = insert(:entity, entity_type: Enum.random(["network", "class"]))

      # EXECUTE
      conn =
        conn
        |> post("/api", %{
          "query" => @create_entity_mutation,
          "variables" => %{name: "Class 2", entityType: "class", parentId: invalid_parent_id}
        })

      # ASSERT
      assert %{
               "errors" => [
                 %{
                   "message" => "[parent_id: \"Classes can only be children of schools.\"]"
                 }
               ]
             } = json_response(conn, 200)
    end
  end
end
