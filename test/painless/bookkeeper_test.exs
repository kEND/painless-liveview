defmodule Painless.BookkeeperTest do
  use Painless.DataCase

  alias Painless.Bookkeeper

  describe "entries" do
    alias Painless.Bookkeeper.Entry

    import Painless.AccountsFixtures
    import Painless.BookkeeperFixtures
    import Painless.LeasingAgentFixtures

    @invalid_attrs %{amount: nil, description: nil, transaction_date: nil, transaction_type: nil}

    test "list_entries/1 returns all entries for a tenancy" do
      tenancy = tenancy_fixture()
      other_tenancy = tenancy_fixture()
      entry = entry_fixture(%{tenancy: tenancy})
      _other = entry_fixture(%{tenancy: other_tenancy})

      assert Bookkeeper.list_entries(tenancy.id) == [entry]
    end

    test "get_entry!/1 returns the entry with given id" do
      entry = entry_fixture()
      assert Bookkeeper.get_entry!(entry.id) == entry
    end

    test "create_entry/1 with valid data creates a entry" do
      tenancy = tenancy_fixture()

      valid_attrs = %{
        amount: 42,
        description: "some description",
        transaction_date: ~D[2023-07-08],
        transaction_type: "receivable",
        tenancy_id: tenancy.id
      }

      assert {:ok, %Entry{} = entry} = Bookkeeper.create_entry(valid_attrs)
      assert entry.amount == %Money{amount: 42, currency: :USD}
      assert entry.description == "some description"
      assert entry.transaction_date == ~D[2023-07-08]
      assert entry.transaction_type == "receivable"
      assert entry.created_by_id == nil
      assert entry.created_by == nil
    end

    test "create_entry/2 captures the creating user" do
      tenancy = tenancy_fixture()
      user = user_fixture(%{email: "ken.barker@gmail.com"})

      valid_attrs = %{
        amount: 42,
        description: "some description",
        transaction_date: ~D[2023-07-08],
        transaction_type: "receivable",
        tenancy_id: tenancy.id
      }

      assert {:ok, %Entry{} = entry} = Bookkeeper.create_entry(user, valid_attrs)
      assert entry.created_by_id == user.id
      assert entry.created_by.id == user.id
      assert entry.created_by.email == "ken.barker@gmail.com"
    end

    test "create_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bookkeeper.create_entry(@invalid_attrs)
    end

    test "update_entry/2 with valid data updates a entry" do
      user = user_fixture(%{email: "ken.barker@gmail.com"})
      entry = entry_fixture(%{created_by: user})

      update_attrs = %{
        amount: 43,
        description: "some updated description",
        transaction_date: ~D[2023-07-09],
        transaction_type: "income",
        created_by_id: user_fixture().id
      }

      assert {:ok, %Entry{} = entry} = Bookkeeper.update_entry(entry, update_attrs)
      assert entry.amount == %Money{amount: 43, currency: :USD}
      assert entry.description == "some updated description"
      assert entry.transaction_date == ~D[2023-07-09]
      assert entry.transaction_type == "income"
      assert entry.created_by_id == user.id
      assert entry.created_by.email == "ken.barker@gmail.com"
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
