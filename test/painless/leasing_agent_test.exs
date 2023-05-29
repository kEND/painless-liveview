defmodule Painless.LeasingAgentTest do
  use Painless.DataCase

  alias Painless.LeasingAgent
  alias Painless.LeasingAgent.Tenancy

  describe "new/1" do
    test "constructs a tenancy data structure from string-based input not persisted to the database" do
      leasing_agent = LeasingAgent.new(%{"name" => "Jon & Nita Gomez"})
      assert leasing_agent.current_tenancy.name == "Jon & Nita Gomez"
      assert leasing_agent.saved_tenancy? == false

      assert leasing_agent.current_tenancy == %Tenancy{
               active: true,
               id: nil,
               inserted_at: nil,
               name: "Jon & Nita Gomez",
               notes: nil,
               property: nil,
               rent_day_of_month: 1,
               updated_at: nil
             }
    end
  end
end
