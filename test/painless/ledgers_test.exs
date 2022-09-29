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

  describe "entries" do
    alias Painless.Ledgers.Entry

    import Painless.LedgersFixtures

    @invalid_attrs %{amount: nil, description: nil, transaction_date: nil}

    test "list_entries/0 returns all entries" do
      entry = entry_fixture()
      assert Ledgers.list_entries() == [entry]
    end

    test "get_entry!/1 returns the entry with given id" do
      entry = entry_fixture()
      assert Ledgers.get_entry!(entry.id) == entry
    end

    test "create_entry/1 with valid data creates a entry" do
      valid_attrs = %{amount: 42, description: "some description", transaction_date: ~N[2022-09-28 03:04:00]}

      assert {:ok, %Entry{} = entry} = Ledgers.create_entry(valid_attrs)
      assert entry.amount == 42
      assert entry.description == "some description"
      assert entry.transaction_date == ~N[2022-09-28 03:04:00]
    end

    test "create_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ledgers.create_entry(@invalid_attrs)
    end

    test "update_entry/2 with valid data updates the entry" do
      entry = entry_fixture()
      update_attrs = %{amount: 43, description: "some updated description", transaction_date: ~N[2022-09-29 03:04:00]}

      assert {:ok, %Entry{} = entry} = Ledgers.update_entry(entry, update_attrs)
      assert entry.amount == 43
      assert entry.description == "some updated description"
      assert entry.transaction_date == ~N[2022-09-29 03:04:00]
    end

    test "update_entry/2 with invalid data returns error changeset" do
      entry = entry_fixture()
      assert {:error, %Ecto.Changeset{}} = Ledgers.update_entry(entry, @invalid_attrs)
      assert entry == Ledgers.get_entry!(entry.id)
    end

    test "delete_entry/1 deletes the entry" do
      entry = entry_fixture()
      assert {:ok, %Entry{}} = Ledgers.delete_entry(entry)
      assert_raise Ecto.NoResultsError, fn -> Ledgers.get_entry!(entry.id) end
    end

    test "change_entry/1 returns a entry changeset" do
      entry = entry_fixture()
      assert %Ecto.Changeset{} = Ledgers.change_entry(entry)
    end
  end
end
