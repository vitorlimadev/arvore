defmodule Arvore.Entities do
  @moduledoc """
  The Entities context.

  Entities are the only database model. They represent school networks, schools and classes based on
  the `type` key, and are related through their `parent_id` keys.

  * A `network` may have many `schools` as children. It cannot have a parent.

  * A `school` may have only one `network` as parent, and many `classes` as children.

  * A `class` may have only one `school` as parent and no children.

  The `subtree_ids` key must contain the ids of all the entity's children, and their children
  recursively.

  Ex: A network has 100 schools, and each school has 1 to 10 classes. `subtree_ids` must contain the
  ids of all related schools and classes.
  """

  import Ecto.Query, warn: false
  alias Arvore.Repo

  alias Arvore.Entities.Entity

  @doc """
  Gets a single `Entity` and populate it's children's ids in `subtree_ids` virtual key.
  `subtree_ids` is populated with a recursive CTE.

  ## Examples

      iex> fetch_entity(123)
      {:ok, %Entity{}}

      iex> fetch_entity(456)
      {:error, :NOT_FOUND}

  """
  @spec fetch_entity(id :: Integer.t(), fetch_children? :: keyword()) ::
          {:ok, Entity.t()} | {:error, :NOT_FOUND}
  def fetch_entity(id, opts \\ []) do
    fetch_children? = Keyword.get(opts, :fetch_children?, false)

    case Repo.get(Entity, id) do
      %Entity{} = entity ->
        build_entity(entity, fetch_children?)

      nil ->
        {:error, :NOT_FOUND}
    end
  end

  defp build_entity(entity, true) do
    children = fetch_all_children(entity.id)

    {:ok, Map.put(entity, :subtree_ids, children)}
  end

  defp build_entity(entity, false), do: {:ok, entity}

  defp fetch_all_children(entity_id) do
    recursive_cte = """
      WITH RECURSIVE children_entities AS (
        SELECT id, parent_id
        FROM entities
        WHERE id = #{entity_id}
        
        UNION ALL
        
        SELECT e.id, e.parent_id
        FROM entities e
        INNER JOIN children_entities ce ON e.parent_id = ce.id
      )

      SELECT * FROM children_entities;
    """

    # First row is ignored as the result of the anchor member (first query before the UNION) is also
    # part of the result. This will always be the entity we wanted to fetch the children from,
    # and we don't want it's own id in it's `subtree_ids`.
    %{rows: [_ | result]} = Repo.query!(recursive_cte)

    Enum.map(result, fn [id, _parent_id] -> id end)
  end

  @doc """
  Creates a entity.

  ## Examples

      iex> create_entity(%{name: "name", entity_type: "school"})
      {:ok, %Entity{}}

      iex> create_entity(%{})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_entity(attrs :: map()) :: {:ok, Entity.t()} | {:error, Ecto.Changeset.t()}
  def create_entity(attrs) do
    %Entity{}
    |> Entity.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a entity.

  `entity_type` cannot be updated, as it would break parental hierarchy.

  ## Examples

      iex> update_entity(entity, %{name: "new_name"})
      {:ok, %Entity{}}

      iex> update_entity(entity, %{invalid: "field"})
      {:error, %Ecto.Changeset{}}

  """
  @spec update_entity(entity :: Entity.t(), attrs :: map()) ::
          {:ok, Entity.t()} | {:error, Ecto.Changeset.t()}
  def update_entity(%Entity{} = entity, attrs) do
    attrs = Map.drop(attrs, [:entity_type])

    entity
    |> Entity.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Checks if an entity exists in the database.

  ## Examples

      iex> exists?(entity_id)
      true

  """
  @spec exists?(id :: Integer.t()) :: boolean()
  def exists?(id), do: Repo.exists?(Entity, id: id)
end
