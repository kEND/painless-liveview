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
end
