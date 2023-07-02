defmodule Painless.LeasingAgentFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Painless.LeasingAgent` context.
  """

  @doc """
  Generate a tenancy.
  """
  def tenancy_fixture(attrs \\ %{}) do
    {:ok, tenancy} =
      attrs
      |> Enum.into(%{
        active: true,
        late_fee: 42,
        name: "some name",
        notes: "some notes",
        property: "some property",
        recurring: true,
        recurring_description: "some recurring_description",
        rent: 42,
        rent_day_of_month: 42
      })
      |> Painless.LeasingAgent.create_tenancy()

    tenancy
  end
end
