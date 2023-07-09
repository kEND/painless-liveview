defmodule Painless.BookkeeperTest do
  use Painless.DataCase

  alias Painless.Bookkeeper

  describe "entries" do
    alias Painless.Bookkeeper.Entry

    import Painless.BookkeeperFixtures

    @invalid_attrs %{amount: nil, description: nil, transaction_date: nil, transaction_type: nil}

    test "list_entries/0 returns all entries" do
      entry = entry_fixture()
      assert Bookkeeper.list_entries() == [entry]
    end

    test "get_entry!/1 returns the entry with given id" do
      entry = entry_fixture()
      assert Bookkeeper.get_entry!(entry.id) == entry
    end

    test "create_entry/1 with valid data creates a entry" do
      valid_attrs = %{amount: 42, description: "some description", transaction_date: ~D[2023-07-08], transaction_type: "some transaction_type"}

      assert {:ok, %Entry{} = entry} = Bookkeeper.create_entry(valid_attrs)
      assert entry.amount == 42
      assert entry.description == "some description"
      assert entry.transaction_date == ~D[2023-07-08]
      assert entry.transaction_type == "some transaction_type"
    end

    test "create_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bookkeeper.create_entry(@invalid_attrs)
    end

    test "update_entry/2 with valid data updates the entry" do
      entry = entry_fixture()
      update_attrs = %{amount: 43, description: "some updated description", transaction_date: ~D[2023-07-09], transaction_type: "some updated transaction_type"}

      assert {:ok, %Entry{} = entry} = Bookkeeper.update_entry(entry, update_attrs)
      assert entry.amount == 43
      assert entry.description == "some updated description"
      assert entry.transaction_date == ~D[2023-07-09]
      assert entry.transaction_type == "some updated transaction_type"
    end

    test "update_entry/2 with invalid data returns error changeset" do
      entry = entry_fixture()
      assert {:error, %Ecto.Changeset{}} = Bookkeeper.update_entry(entry, @invalid_attrs)
      assert entry == Bookkeeper.get_entry!(entry.id)
    end

    test "delete_entry/1 deletes the entry" do
      entry = entry_fixture()
      assert {:ok, %Entry{}} = Bookkeeper.delete_entry(entry)
      assert_raise Ecto.NoResultsError, fn -> Bookkeeper.get_entry!(entry.id) end
    end

    test "change_entry/1 returns a entry changeset" do
      entry = entry_fixture()
      assert %Ecto.Changeset{} = Bookkeeper.change_entry(entry)
    end
  end
end
