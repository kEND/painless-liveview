defmodule Painless.Repo.Migrations.CreateTenancyNotes do
  use Ecto.Migration

  def change do
    create table(:tenancy_notes) do
      add :body, :text, null: false
      add :tenancy_id, references(:tenancies, type: :integer, on_delete: :delete_all), null: false
      add :user_id, references(:users, type: :bigint, on_delete: :restrict), null: false

      timestamps()
    end

    create index(:tenancy_notes, [:tenancy_id])
    create index(:tenancy_notes, [:user_id])
  end
end
