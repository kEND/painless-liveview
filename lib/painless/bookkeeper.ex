defmodule Painless.Bookkeeper do
  alias Painless.Bookkeeper.Core
  alias Painless.Bookkeeper.Entry
  alias Painless.LeasingAgent.Tenancy

  def open(%Tenancy{} = tenancy) do
    %{tenancy | entries: Core.entries(tenancy), balance: balance(tenancy)}
  end

  # def balance(nil), do: Money.new(0)

  def balance(%Tenancy{} = tenancy, at \\ NaiveDateTime.local_now()) do
    Core.balance(tenancy, at)
  end

  def get_entry!(id) do
    Core.get_entry!(id)
  end

  def change_entry(%Entry{} = entry, attrs \\ %{}) do
    Core.change_entry(entry, attrs)
  end

  def create_entry(attrs \\ %{}) do
    Core.create_entry(attrs)
  end

  def update_entry(%Entry{} = entry, attrs) do
    Core.update_entry(entry, attrs)
  end

  def delete_entry(%Entry{} = entry) do
    Core.delete_entry(entry)
  end
end
