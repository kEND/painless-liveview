defmodule Painless.TenanciesTest do
  use Painless.DataCase

  alias Painless.Tenancies

  describe "tenancies" do
    alias Painless.Tenancies.Tenancy

    import Painless.TenanciesFixtures

    @invalid_attrs %{
      active: nil,
      balance: nil,
      late_fee: nil,
      name: nil,
      notes: nil,
      property: nil,
      rent: nil,
      rent_day_of_month: nil
    }

    test "list_tenancies/0 returns all tenancies" do
      tenancy = tenancy_fixture()
      assert Tenancies.list_tenancies() == [tenancy]
    end

    test "get_tenancy!/1 returns the tenancy with given id" do
      tenancy = tenancy_fixture()
      assert Tenancies.get_tenancy!(tenancy.id) == tenancy
    end

    test "create_tenancy/1 with valid data creates a tenancy" do
      valid_attrs = %{
        active: true,
        balance: 42,
        late_fee: 42,
        name: "some name",
        notes: "some notes",
        property: "some property",
        rent: 42,
        rent_day_of_month: 2
      }

      assert {:ok, %Tenancy{} = tenancy} = Tenancies.create_tenancy(valid_attrs)
      assert tenancy.active == true
      assert tenancy.balance == Money.new(42)
      assert tenancy.late_fee == Money.new(42)
      assert tenancy.name == "some name"
      assert tenancy.notes == "some notes"
      assert tenancy.property == "some property"
      assert tenancy.rent == Money.new(42)
      assert tenancy.rent_day_of_month == 2
    end

    test "create_tenancy/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tenancies.create_tenancy(@invalid_attrs)
    end

    test "update_tenancy/2 with valid data updates the tenancy" do
      tenancy = tenancy_fixture()

      update_attrs = %{
        active: false,
        balance: 43,
        late_fee: 43,
        name: "some updated name",
        notes: "some updated notes",
        property: "some updated property",
        rent: 43,
        rent_day_of_month: 3
      }

      assert {:ok, %Tenancy{} = tenancy} = Tenancies.update_tenancy(tenancy, update_attrs)
      assert tenancy.active == false
      assert tenancy.balance == Money.new(43)
      assert tenancy.late_fee == Money.new(43)
      assert tenancy.name == "some updated name"
      assert tenancy.notes == "some updated notes"
      assert tenancy.property == "some updated property"
      assert tenancy.rent == Money.new(43)
      assert tenancy.rent_day_of_month == 3
    end

    test "update_tenancy/2 with invalid data returns error changeset" do
      tenancy = tenancy_fixture()
      assert {:error, %Ecto.Changeset{}} = Tenancies.update_tenancy(tenancy, @invalid_attrs)
      assert tenancy == Tenancies.get_tenancy!(tenancy.id)
    end

    test "delete_tenancy/1 deletes the tenancy" do
      tenancy = tenancy_fixture()
      assert {:ok, %Tenancy{}} = Tenancies.delete_tenancy(tenancy)
      assert_raise Ecto.NoResultsError, fn -> Tenancies.get_tenancy!(tenancy.id) end
    end

    test "change_tenancy/1 returns a tenancy changeset" do
      tenancy = tenancy_fixture()
      assert %Ecto.Changeset{} = Tenancies.change_tenancy(tenancy)
    end
  end
end
