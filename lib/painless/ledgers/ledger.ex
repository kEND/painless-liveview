defmodule Painless.Ledgers.Ledger do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ledgers" do
    field :acct_type, :string
    field :balance, Money.Ecto.Amount.Type
    field :name, :string

    belongs_to :tenancy, Painless.Tenancies.Tenancy
    # has_many :entries, Painless.Ledgers.Entry
  end

  @doc false
  def changeset(ledger, attrs) do
    ledger
    |> cast(attrs, [:tenancy_id, :name, :acct_type, :balance])
    |> validate_required([:tenancy_id, :name, :acct_type, :balance])
  end
end
