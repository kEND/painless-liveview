defmodule Painless.Repo.Migrations.SetRecurringToTrueIfActive do
  use Ecto.Migration

  def change do
    execute """
            UPDATE tenancies
            SET recurring = true,
                recurring_description = 'Rent Due'
            WHERE active = true
            """,
            """
            UPDATE tenancies
            SET recurring = false,
                recurring_description = NULL
            """
  end
end
