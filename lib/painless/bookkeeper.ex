defmodule Painless.Bookkeeper do
  alias Painless.Bookkeeper.Core
  alias Painless.LeasingAgent.Tenancy

  def entries(%Tenancy{} = tenancy) do
    Core.entries(tenancy)
  end
end
