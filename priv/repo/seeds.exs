alias Arvore.Repo
alias Arvore.Entities.Entity

%{id: network_id} =
  %Entity{}
  |> Entity.changeset(%{name: "Network", entity_type: "network"})
  |> Repo.insert!()

# Create a random amount of schools and classes
schools_amount = 1_000
classes_amount = 1..5 |> Enum.random()

Enum.map(1..schools_amount, fn i ->
  %{id: school_id} =
    %Entity{}
    |> Entity.changeset(%{name: "School #{i}", entity_type: "school", parent_id: network_id})
    |> Repo.insert!()

  Enum.map(1..classes_amount, fn y ->
    %Entity{}
    |> Entity.changeset(%{name: "Class #{i}#{y}", entity_type: "class", parent_id: school_id})
    |> Repo.insert!()
  end)
end)
