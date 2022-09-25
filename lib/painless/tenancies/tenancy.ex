defmodule Painless.Tenancies.Tenancy do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tenancies" do
    field :active, :boolean, default: false
    field :balance, :integer
    field :late_fee, :integer
    field :name, :string
    field :notes, :string
    field :property, :string
    field :rent, :integer
    field :rent_day_of_month, :integer

    timestamps()
  end

  @doc false
  def changeset(tenancy, attrs) do
    tenancy
    |> cast(attrs, [:name, :property, :notes, :rent, :late_fee, :balance, :active, :rent_day_of_month])
    |> validate_required([:name, :property, :notes, :rent, :late_fee, :balance, :active, :rent_day_of_month])
  end
end
