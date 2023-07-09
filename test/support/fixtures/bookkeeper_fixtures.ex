defmodule Painless.BookkeeperFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Painless.Bookkeeper` context.
  """

  @doc """
  Generate a entry.
  """
  def entry_fixture(attrs \\ %{}) do
    {:ok, entry} =
      attrs
      |> Enum.into(%{
        amount: 42,
        description: "some description",
        transaction_date: ~D[2023-07-08],
        transaction_type: "some transaction_type"
      })
      |> Painless.Bookkeeper.create_entry()

    entry
  end
end
