-- If you created any enitities before running the seeder, drop the local database and run the seeder
-- before running this test. This will query for a network with thousands of entities in it's subtree.

math.randomseed(os.time())

wrk.method = "POST"
wrk.headers["Content-Type"] = "application/json"
wrk.headers["Accept"] = "application/json"
wrk.headers["x-api-key"] = "test_key"

local query = [[
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
]]

wrk.body = '{"query": "' .. string.gsub(query, '\n', '') .. '", "variables": {"id": 1}}'
