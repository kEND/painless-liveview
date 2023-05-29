defmodule Painless.LeasingAgent.Tenancy do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tenancies" do
    field :active, :boolean, default: true
    field :balance, Money.Ecto.Amount.Type, virtual: true
    field :late_fee, Money.Ecto.Amount.Type
    field :name, :string
    field :notes, :string
    field :property, :string
    field :rent, Money.Ecto.Amount.Type
    field :rent_day_of_month, :integer, default: 1

    timestamps()

    # has_many :ledgers, Painless.Ledgers.Ledger
  end

  @fields [
    :name,
    :property,
    :notes,
    :rent,
    :late_fee,
    :active,
    :rent_day_of_month
  ]

  @required_fields [:name, :property]

  @doc false
  def changeset(tenancy, attrs) do
    tenancy
    |> cast(attrs, @fields)
    |> validate_required(@required_fields)
  end
end
