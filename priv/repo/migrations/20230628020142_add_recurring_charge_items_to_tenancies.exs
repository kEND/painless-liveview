defmodule Painless.Repo.Migrations.AddRecurringChargeItemsToTenancies do
  use Ecto.Migration

  def change do
    alter table(:tenancies) do
      add :recurring, :boolean, default: false
      add :recurring_description, :string
    end
  end
end
