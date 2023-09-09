defmodule Arvore.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Arvore.Repo

  def entity_factory do
    type = sequence(:entity_type, ["network", "school", "class"])
    inep = if type == "school", do: sequence(:inep, &"inep_#{&1}"), else: nil

    %Arvore.Entities.Entity{
      name: sequence(:name, &"name_#{&1}"),
      entity_type: type,
      inep: inep,
      parent_id: nil,
      subtree_ids: []
    }
  end
end
