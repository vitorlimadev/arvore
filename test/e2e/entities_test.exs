defmodule EntitiesTest do
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
      entityType
      inep
      parentId
      subtreeIds
    }
  }
  """

  @fetch_entity_query """
  query GetEntity($id: Int!) {
    getEntity(id: $id) {
      id
      name
      entityType
      inep
      parentId
      subtreeIds
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
                   "entityType" => "network",
                   "parentId" => nil,
                   "inep" => nil,
                   "subtreeIds" => []
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
                   "parentId" => ^network_id
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

  describe "fetch_entity sucess cases" do
    test "fetches an existing entity", %{conn: conn} do
      # SETUP

      # Create a random type entity
      %{
        id: id,
        name: name,
        entity_type: entity_type,
        inep: inep
      } = insert(:entity)

      entity_type = Atom.to_string(entity_type)

      # EXECUTE
      conn =
        conn
        |> post("/api", %{
          "query" => @fetch_entity_query,
          "variables" => %{id: id}
        })

      # ASSERT
      assert %{
               "data" => %{
                 "getEntity" => %{
                   "id" => ^id,
                   "name" => ^name,
                   "entityType" => ^entity_type,
                   "parentId" => nil,
                   "inep" => ^inep,
                   "subtreeIds" => []
                 }
               }
             } = json_response(conn, 200)
    end

    test "fetches correct parent_id", %{conn: conn} do
      # SETUP

      # Create the network parent
      %{id: network_id} = insert(:entity, entity_type: "network")

      # Create the fetched school
      %{id: school_id} = insert(:entity, entity_type: "school", parent_id: network_id)

      # EXECUTE
      conn =
        conn
        |> post("/api", %{
          "query" => @fetch_entity_query,
          "variables" => %{id: school_id}
        })

      # ASSERT
      assert %{
               "data" => %{
                 "getEntity" => %{
                   "id" => ^school_id,
                   "parentId" => ^network_id
                 }
               }
             } = json_response(conn, 200)
    end

    test "fetches a child school id from a network's subtree", %{conn: conn} do
      # SETUP

      # Create the network
      %{id: network_id} = insert(:entity, entity_type: "network")

      # Create the child school
      %{id: school_id} = insert(:entity, entity_type: "school", parent_id: network_id)

      # EXECUTE
      conn =
        conn
        |> post("/api", %{
          "query" => @fetch_entity_query,
          "variables" => %{id: network_id}
        })

      # ASSERT
      assert %{
               "data" => %{
                 "getEntity" => %{
                   "id" => ^network_id,
                   "parentId" => nil,
                   "subtreeIds" => [^school_id]
                 }
               }
             } = json_response(conn, 200)
    end

    test "fetches a child class id from a schools's subtree", %{conn: conn} do
      # SETUP

      # Create the school
      %{id: school_id} = insert(:entity, entity_type: "school")

      # Create the child class
      %{id: class_id} = insert(:entity, entity_type: "class", parent_id: school_id)

      # EXECUTE
      conn =
        conn
        |> post("/api", %{
          "query" => @fetch_entity_query,
          "variables" => %{id: school_id}
        })

      # ASSERT
      assert %{
               "data" => %{
                 "getEntity" => %{
                   "id" => ^school_id,
                   "parentId" => nil,
                   "subtreeIds" => [^class_id]
                 }
               }
             } = json_response(conn, 200)
    end

    test "fetches multiple schools and classes from within a network subtree", %{conn: conn} do
      # SETUP

      # Create the fetched network
      %{id: network_id} = insert(:entity, entity_type: "network")

      # Create a random amount of schools and classes
      schools_amount = 1..10 |> Enum.random()
      classes_amount = 1..3 |> Enum.random()

      subtree_ids =
        Enum.map(1..schools_amount, fn _ ->
          %{id: school_id} = insert(:entity, entity_type: "school", parent_id: network_id)

          class_ids =
            Enum.map(1..classes_amount, fn _ ->
              %{id: class_id} = insert(:entity, entity_type: "class", parent_id: school_id)

              class_id
            end)

          class_ids ++ [school_id]
        end)
        |> List.flatten()

      # EXECUTE
      conn =
        conn
        |> post("/api", %{
          "query" => @fetch_entity_query,
          "variables" => %{id: network_id}
        })

      # ASSERT
      assert %{
               "data" => %{
                 "getEntity" => %{
                   "id" => ^network_id,
                   "parentId" => nil,
                   "subtreeIds" => subtree_ids_response
                 }
               }
             } = json_response(conn, 200)

      assert Enum.sort(subtree_ids) == Enum.sort(subtree_ids_response)
    end
  end

  describe "fetch_entity error cases" do
    test "handles empty payload", %{conn: conn} do
      # EXECUTE
      conn =
        conn
        |> post("/api", %{
          "query" => @fetch_entity_query,
          "variables" => %{}
        })

      # ASSERT
      assert %{
               "errors" => [
                 %{
                   "message" => "In argument \"id\": Expected type \"Int!\", found null."
                 }
                 | _
               ]
             } = json_response(conn, 200)
    end

    test "handles entity not found", %{conn: conn} do
      # EXECUTE
      conn =
        conn
        |> post("/api", %{
          "query" => @fetch_entity_query,
          "variables" => %{id: 0}
        })

      # ASSERT
      assert %{"errors" => [%{"message" => "NOT_FOUND"}]} = json_response(conn, 200)
    end
  end
end
