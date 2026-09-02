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

  @doc """
  Generate a tenancy note.
  """
  def tenancy_note_fixture(attrs \\ %{}) do
    {tenancy, attrs} = Map.pop_lazy(attrs, :tenancy, fn -> tenancy_fixture() end)
    {user, attrs} = Map.pop_lazy(attrs, :user, fn -> Painless.AccountsFixtures.user_fixture() end)

    attrs = Enum.into(attrs, %{body: "some note body"})

    {:ok, tenancy_note} = Painless.LeasingAgent.create_tenancy_note(tenancy, user, attrs)
    tenancy_note
  end
end
