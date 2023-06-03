defmodule Painless.Bookkeeper.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "entries" do
    field :amount, Money.Ecto.Amount.Type
    field :charge, Money.Ecto.Amount.Type, virtual: true
    field :payment, Money.Ecto.Amount.Type, virtual: true
    field :description, :string
    field :transaction_type, :string
    field :transaction_date, :date

    timestamps()

    belongs_to :tenancy, Painless.LeasingAgent.Tenancy
  end

  @fields [
    :tenancy_id,
    :description,
    :amount,
    :transaction_date,
    :transaction_type
  ]

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
