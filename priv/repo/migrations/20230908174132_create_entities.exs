defmodule Arvore.Repo.Migrations.CreateEntities do
  use Ecto.Migration

  def change do
    create table(:entities) do
      add :name, :string, null: false
      add :entity_type, :string, null: false
      add :parent_id, :integer
      add :inep, :string

      timestamps()
    end

    create unique_index(:entities, [:name, :entity_type])
    create index(:entities, [:parent_id])
  end
end
