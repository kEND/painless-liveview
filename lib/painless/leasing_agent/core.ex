defmodule Painless.LeasingAgent.Core do
  import Ecto.Query, warn: false

  alias Painless.LeasingAgent.Tenancy
  alias Painless.Repo

  def find_tenancy(params) do
    Tenancy
    |> where([t], name: ^params["name"], property: ^params["property"])
    |> Repo.one()
  end

  def tenancies(active \\ true) do
    Tenancy
    |> where([t], t.active == ^active)
    |> order_by([t], asc: t.property, asc: t.name)
    |> Repo.all()
  end
end
