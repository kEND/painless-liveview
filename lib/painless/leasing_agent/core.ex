defmodule Painless.LeasingAgent.Core do
  import Ecto.Query, warn: false

  alias Painless.LeasingAgent.Tenancy
  alias Painless.Repo

  def find_tenancy(params) do
    Tenancy
    |> where([t], name: ^params["name"], property: ^params["property"])
    |> Repo.one()
  end
end
