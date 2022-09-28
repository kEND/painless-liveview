defmodule Painless.LedgersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Painless.Ledgers` context.
  """

  @doc """
  Generate a ledger.
  """
  def ledger_fixture(attrs \\ %{}) do
    {:ok, ledger} =
      attrs
      |> Enum.into(%{
        acct_type: "some acct_type",
        balance: 42,
        name: "some name"
      })
      |> Painless.Ledgers.create_ledger()

    ledger
  end
end
