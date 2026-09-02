defmodule Painless.LeasingAgent.TenancyNote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tenancy_notes" do
    field :body, :string

    belongs_to :tenancy, Painless.LeasingAgent.Tenancy
    belongs_to :user, Painless.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(tenancy_note, attrs) do
    tenancy_note
    |> cast(attrs, [:body])
    |> validate_required([:body])
    |> foreign_key_constraint(:tenancy_id)
    |> foreign_key_constraint(:user_id)
  end
end
