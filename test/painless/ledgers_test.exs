defmodule Painless.LedgersTest do
  use Painless.DataCase

  alias Painless.Ledgers

  describe "ledgers" do
    alias Painless.Ledgers.Ledger

    import Painless.LedgersFixtures

    @invalid_attrs %{acct_type: nil, balance: nil, name: nil}

    test "list_ledgers/0 returns all ledgers" do
      ledger = ledger_fixture()
      assert Ledgers.list_ledgers() == [ledger]
    end

    test "get_ledger!/1 returns the ledger with given id" do
      ledger = ledger_fixture()
      assert Ledgers.get_ledger!(ledger.id) == ledger
    end

    test "create_ledger/1 with valid data creates a ledger" do
      valid_attrs = %{acct_type: "some acct_type", balance: 42, name: "some name"}

      assert {:ok, %Ledger{} = ledger} = Ledgers.create_ledger(valid_attrs)
      assert ledger.acct_type == "some acct_type"
      assert ledger.balance == 42
      assert ledger.name == "some name"
    end

    test "create_ledger/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ledgers.create_ledger(@invalid_attrs)
    end

    test "update_ledger/2 with valid data updates the ledger" do
      ledger = ledger_fixture()
      update_attrs = %{acct_type: "some updated acct_type", balance: 43, name: "some updated name"}

      assert {:ok, %Ledger{} = ledger} = Ledgers.update_ledger(ledger, update_attrs)
      assert ledger.acct_type == "some updated acct_type"
      assert ledger.balance == 43
      assert ledger.name == "some updated name"
    end

    test "update_ledger/2 with invalid data returns error changeset" do
      ledger = ledger_fixture()
      assert {:error, %Ecto.Changeset{}} = Ledgers.update_ledger(ledger, @invalid_attrs)
      assert ledger == Ledgers.get_ledger!(ledger.id)
    end

    test "delete_ledger/1 deletes the ledger" do
      ledger = ledger_fixture()
      assert {:ok, %Ledger{}} = Ledgers.delete_ledger(ledger)
      assert_raise Ecto.NoResultsError, fn -> Ledgers.get_ledger!(ledger.id) end
    end

    test "change_ledger/1 returns a ledger changeset" do
      ledger = ledger_fixture()
      assert %Ecto.Changeset{} = Ledgers.change_ledger(ledger)
    end
  end
end
