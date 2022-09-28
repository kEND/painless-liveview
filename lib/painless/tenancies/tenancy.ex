defmodule Painless.Tenancies.Tenancy do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tenancies" do
    field :active, :boolean, default: false
    field :balance, Money.Ecto.Amount.Type
    field :late_fee, Money.Ecto.Amount.Type
    field :name, :string
    field :notes, :string
    field :property, :string
    field :rent, Money.Ecto.Amount.Type
    field :rent_day_of_month, :integer

    timestamps()

    has_many :ledgers, Painless.Ledgers.Ledger
  end

  @doc false
  def changeset(tenancy, attrs) do
    tenancy
    |> cast(attrs, [:name, :property, :notes, :rent, :late_fee, :balance, :active, :rent_day_of_month])
    |> validate_required([:name, :property, :notes, :rent, :late_fee, :balance, :active, :rent_day_of_month])
  end
end
