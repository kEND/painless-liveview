defmodule Painless.LeasingAgent do
  alias Painless.LeasingAgent.Tenancy

  defstruct current_tenancy: %Tenancy{},
            saved_tenancy?: false

  def new(%{"name" => name, "property" => property, "active" => active}) do
    %__MODULE__{
      current_tenancy: %Tenancy{
        name: name,
        property: property,
        active: active
      }
    }
  end
end
