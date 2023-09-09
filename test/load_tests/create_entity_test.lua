math.randomseed(os.time())

wrk.method = "POST"
wrk.headers["Content-Type"] = "application/json"
wrk.headers["Accept"] = "application/json"
wrk.headers["x-api-key"] = "test_key"

local query = [[
  mutation CreateEntity(
    $name: String!,
    $entityType: String!
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
]]

local name = "school_" .. math.random(1, 999999999999999)

local variables = '"name": "' .. name .. '", "entityType": "school"'

wrk.body = '{"query": "' ..
    string.gsub(query, '\n', '') .. '", "variables": {' .. string.gsub(variables, '\n', '') .. '} }'
