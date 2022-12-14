defmodule Painless.TenanciesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Painless.Tenancies` context.
  """

  @doc """
  Generate a tenancy.
  """
  alias Painless.Repo

  def tenancy_fixture(attrs \\ %{}) do
    {:ok, %{insert_tenancy: %Painless.Tenancies.Tenancy{} = tenancy}} =
      attrs
      |> Enum.into(%{
        active: true,
        balance: 42,
        late_fee: 42,
        name: "some name",
        notes: "some notes",
        property: "some property",
        rent: 42,
        rent_day_of_month: 2
      })
      |> Painless.Tenancies.create_tenancy()

    tenancy |> Repo.preload(:ledgers)
  end
end
