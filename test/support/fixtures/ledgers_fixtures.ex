defmodule Painless.LedgersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Painless.Ledgers` context.
  """

  alias Painless.TenanciesFixtures

  @doc """
  Generate a ledger.
  """
  def ledger_fixture(attrs \\ %{}) do
    {:ok, ledger} =
      attrs
      |> Enum.into(%{
        acct_type: "some acct_type",
        balance: 42,
        name: "some name",
        tenancy_id: TenanciesFixtures.tenancy_fixture().id
      })
      |> Painless.Ledgers.create_ledger()

    ledger
  end

  @doc """
  Generate a entry.
  """
  def entry_fixture(attrs \\ %{}) do
    {:ok, entry} =
      attrs
      |> Enum.into(%{
        amount: 42,
        description: "some description",
        transaction_date: ~N[2022-09-28 03:04:00],
        ledger_id: ledger_fixture().id
      })
      |> Painless.Ledgers.create_entry()

    entry |> Painless.Repo.preload(ledger: :tenancy)
  end
end
