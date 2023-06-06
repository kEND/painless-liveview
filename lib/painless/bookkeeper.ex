defmodule Painless.Bookkeeper do
  alias Painless.Bookkeeper.Core
  alias Painless.LeasingAgent.Tenancy

  def open(%Tenancy{} = tenancy) do
    %{tenancy | entries: Core.entries(tenancy), balance: balance(tenancy)}
  end

  # def balance(nil), do: Money.new(0)

  def balance(%Tenancy{} = tenancy, at \\ NaiveDateTime.local_now()) do
    Core.balance(tenancy, at)
  end
end
