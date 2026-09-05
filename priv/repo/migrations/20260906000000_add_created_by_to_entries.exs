defmodule Painless.Repo.Migrations.AddCreatedByToEntries do
  use Ecto.Migration

  def change do
    alter table(:entries) do
      add :created_by_id, references(:users, type: :bigint, on_delete: :nilify_all)
    end

    create index(:entries, [:created_by_id])
  end
end
