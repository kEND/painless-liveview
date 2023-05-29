defmodule Painless.LeasingAgent do
  alias Painless.LeasingAgent.Core
  alias Painless.LeasingAgent.Tenancy

  defstruct current_tenancy: %Tenancy{},
            saved_tenancy?: false

  def new(%{"name" => name, "property" => property} = params) do
    case Core.find_tenancy(params) do
      nil ->
        %__MODULE__{current_tenancy: %Tenancy{name: name, property: property}}

      tenancy ->
        %__MODULE__{current_tenancy: tenancy}
    end
  end
end
