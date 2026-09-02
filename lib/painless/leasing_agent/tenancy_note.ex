defmodule Painless.LeasingAgent.TenancyNote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tenancy_notes" do
    field :body, :string
    field :noted_at, :naive_datetime

    belongs_to :tenancy, Painless.LeasingAgent.Tenancy
    belongs_to :user, Painless.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(tenancy_note, attrs) do
    tenancy_note
    |> cast(attrs, [:body, :noted_at])
    |> put_noted_at_default()
    |> validate_required([:body, :noted_at])
    |> foreign_key_constraint(:tenancy_id)
    |> foreign_key_constraint(:user_id)
  end

  def now do
    NaiveDateTime.local_now() |> NaiveDateTime.truncate(:second)
  end

  defp put_noted_at_default(changeset) do
    case fetch_change(changeset, :noted_at) do
      {:ok, _} ->
        changeset

      :error ->
        if get_field(changeset, :noted_at) do
          changeset
        else
          put_change(changeset, :noted_at, now())
        end
    end
  end
end
