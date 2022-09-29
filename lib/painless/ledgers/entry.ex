defmodule Painless.Ledgers.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "entries" do
    field :amount, Money.Ecto.Amount.Type
    field :charge, Money.Ecto.Amount.Type, virtual: true
    field :payment, Money.Ecto.Amount.Type, virtual: true
    field :description, :string
    field :transaction_date, :date

    timestamps()

    belongs_to :ledger, Painless.Ledgers.Ledger
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:ledger_id, :description, :amount, :transaction_date])
    |> validate_required([:ledger_id, :description, :amount, :transaction_date])
  end
end
