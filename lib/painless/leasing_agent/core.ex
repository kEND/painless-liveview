defmodule Painless.LeasingAgent.Core do
  import Ecto.Query, warn: false

  alias Painless.LeasingAgent.Tenancy
  alias Painless.Repo

  def find_tenancy(params) do
    Tenancy
    |> where([t], name: ^params["name"], property: ^params["property"])
    |> Repo.one()
    |> case do
      nil -> nil
      tenancy -> set_balance(tenancy)
    end
  end

  def get!(id), do: Repo.get!(Tenancy, id)

  def tenancies(active \\ true) do
    Tenancy
    |> where([t], t.active == ^active)
    |> order_by([t], asc: t.property, asc: t.name)
    |> Repo.all()
    |> Enum.map(&set_balance/1)
  end

  def set_balance(tenancy) do
    %{tenancy | balance: Painless.Bookkeeper.balance(tenancy)}
  end
end
