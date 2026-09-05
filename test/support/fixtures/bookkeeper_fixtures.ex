defmodule Painless.BookkeeperFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Painless.Bookkeeper` context.
  """

  @doc """
  Generate a entry.
  """
  def entry_fixture(attrs \\ %{}) do
    {tenancy, attrs} = Map.pop_lazy(attrs, :tenancy, fn -> Painless.LeasingAgentFixtures.tenancy_fixture() end)
    {created_by, attrs} = Map.pop(attrs, :created_by)

    attrs =
      Enum.into(attrs, %{
        amount: 42,
        description: "some description",
        transaction_date: ~D[2023-07-08],
        transaction_type: "receivable",
        tenancy_id: tenancy.id
      })

    {:ok, entry} =
      case created_by do
        nil -> Painless.Bookkeeper.create_entry(attrs)
        user -> Painless.Bookkeeper.create_entry(user, attrs)
      end

    entry
  end
end
