defmodule ArvoreWeb.Schema.EntitiesTest do
  use ArvoreWeb.ConnCase, async: true

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
          "variables" => %{name: "Test 1", entityType: "network"}
        })

      # ASSERT
      assert %{
               "data" => %{
                 "createEntity" => %{
                   "id" => _,
                   "name" => "Test 1"
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
               ]
             } = json_response(conn, 200)
    end
  end
end
