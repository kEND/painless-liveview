defmodule Painless.LeasingAgentTest do
  use Painless.DataCase

  alias Painless.LeasingAgent
  alias Painless.LeasingAgent.Tenancy

  describe "new/1" do
    test "constructs a tenancy data structure from string-based input not persisted to the database" do
      leasing_agent = LeasingAgent.new(%{"name" => "Jon & Nita Gomez", "property" => "123 Main St."})

      assert leasing_agent.current_tenancy.name == "Jon & Nita Gomez"
      assert leasing_agent.saved_tenancy? == false

      assert leasing_agent.current_tenancy == %Tenancy{
               active: true,
               id: nil,
               inserted_at: nil,
               name: "Jon & Nita Gomez",
               notes: nil,
               property: "123 Main St.",
               rent_day_of_month: 1,
               updated_at: nil
             }
    end
  end

  describe "tenancies" do
    alias Painless.LeasingAgent.Tenancy

    import Painless.LeasingAgentFixtures

    @invalid_attrs %{
      active: nil,
      late_fee: nil,
      name: nil,
      notes: nil,
      property: nil,
      recurring: nil,
      recurring_description: nil,
      rent: nil,
      rent_day_of_month: nil
    }

    test "list_tenancies/0 returns all tenancies" do
      tenancy = tenancy_fixture()
      assert LeasingAgent.list_tenancies() == [tenancy]
    end

    test "get_tenancy!/1 returns the tenancy with given id" do
      tenancy = tenancy_fixture()
      assert LeasingAgent.get_tenancy!(tenancy.id) == tenancy
    end

    test "create_tenancy/1 with valid data creates a tenancy" do
      valid_attrs = %{
        active: true,
        late_fee: 42,
        name: "some name",
        notes: "some notes",
        property: "some property",
        recurring: true,
        recurring_description: "some recurring_description",
        rent: 42,
        rent_day_of_month: 42
      }

      assert {:ok, %Tenancy{} = tenancy} = LeasingAgent.create_tenancy(valid_attrs)
      assert tenancy.active == true
      assert tenancy.late_fee == 42
      assert tenancy.name == "some name"
      assert tenancy.notes == "some notes"
      assert tenancy.property == "some property"
      assert tenancy.recurring == true
      assert tenancy.recurring_description == "some recurring_description"
      assert tenancy.rent == 42
      assert tenancy.rent_day_of_month == 42
    end

    test "create_tenancy/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LeasingAgent.create_tenancy(@invalid_attrs)
    end

    test "update_tenancy/2 with valid data updates the tenancy" do
      tenancy = tenancy_fixture()

      update_attrs = %{
        active: false,
        late_fee: 43,
        name: "some updated name",
        notes: "some updated notes",
        property: "some updated property",
        recurring: false,
        recurring_description: "some updated recurring_description",
        rent: 43,
        rent_day_of_month: 43
      }

      assert {:ok, %Tenancy{} = tenancy} = LeasingAgent.update_tenancy(tenancy, update_attrs)
      assert tenancy.active == false
      assert tenancy.late_fee == 43
      assert tenancy.name == "some updated name"
      assert tenancy.notes == "some updated notes"
      assert tenancy.property == "some updated property"
      assert tenancy.recurring == false
      assert tenancy.recurring_description == "some updated recurring_description"
      assert tenancy.rent == 43
      assert tenancy.rent_day_of_month == 43
    end

    test "update_tenancy/2 with invalid data returns error changeset" do
      tenancy = tenancy_fixture()
      assert {:error, %Ecto.Changeset{}} = LeasingAgent.update_tenancy(tenancy, @invalid_attrs)
      assert tenancy == LeasingAgent.get_tenancy!(tenancy.id)
    end

    test "delete_tenancy/1 deletes the tenancy" do
      tenancy = tenancy_fixture()
      assert {:ok, %Tenancy{}} = LeasingAgent.delete_tenancy(tenancy)
      assert_raise Ecto.NoResultsError, fn -> LeasingAgent.get_tenancy!(tenancy.id) end
    end

    test "change_tenancy/1 returns a tenancy changeset" do
      tenancy = tenancy_fixture()
      assert %Ecto.Changeset{} = LeasingAgent.change_tenancy(tenancy)
    end
  end
end
