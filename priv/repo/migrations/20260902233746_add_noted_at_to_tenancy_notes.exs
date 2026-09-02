defmodule Painless.Repo.Migrations.AddNotedAtToTenancyNotes do
  use Ecto.Migration

  def change do
    alter table(:tenancy_notes) do
      add :noted_at, :naive_datetime, null: false, default: fragment("CURRENT_TIMESTAMP")
    end
  end
end
