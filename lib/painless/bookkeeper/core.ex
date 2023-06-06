defmodule Painless.Bookkeeper.Core do
  import Ecto.Query, warn: false

  alias Painless.Bookkeeper.Entry
  alias Painless.LeasingAgent.Tenancy
  alias Painless.Repo

  def entries(%Tenancy{} = tenancy) do
    Entry
    |> where([e], e.tenancy_id == ^tenancy.id)
    |> order_by([e], desc: e.transaction_date)
    |> Repo.all()
  end

  def balance(%Tenancy{} = tenancy, at \\ NaiveDateTime.local_now()) do
    Entry
    |> where([e], e.tenancy_id == ^tenancy.id and e.transaction_date <= ^at)
    |> select([e], sum(e.amount))
    |> Repo.one()
  end
end
