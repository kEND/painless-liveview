defmodule Painless.Tenancies do
  @moduledoc """
  The Tenancies context.
  """

  import Ecto.Query, warn: false
  alias Painless.Repo

  alias Painless.Ledgers.Entry
  alias Painless.Ledgers.Ledger
  alias Painless.Tenancies.Tenancy

  @doc """
  Returns the list of tenancies.

  ## Examples

      iex> list_tenancies()
      [%Tenancy{}, ...]

  """
  def list_tenancies(show_active \\ false)

  def list_tenancies(show_active) when show_active == false do
    Repo.all(Tenancy)
  end

  def list_tenancies(show_active) when show_active == true do
    Tenancy
    |> where(active: true)
    |> Repo.all()
  end

  @doc """
  Return the latest 20 entries interwoven by date
  """
  def list_combined_entries(tenancy_id) do
    from(e in Entry)
    |> select_merge([e, l], %{
      charge: type(fragment("CASE ? WHEN 'Receivable' THEN ? ELSE 0 END", l.acct_type, e.amount), Money.Ecto.Type)
    })
    |> select_merge([e, l], %{
      payment: type(fragment("CASE ? WHEN 'Income' THEN ? ELSE 0 END", l.acct_type, e.amount), Money.Ecto.Type)
    })
    |> join(:inner, [e], l in Ledger, on: e.ledger_id == l.id)
    |> where([_, l], l.tenancy_id == ^tenancy_id)
    |> order_by([e], desc: e.transaction_date)
    |> limit([e, l], 20)
    |> Repo.all()
  end

  @doc """
  Gets a single tenancy.

  Raises `Ecto.NoResultsError` if the Tenancy does not exist.

  ## Examples

      iex> get_tenancy!(123)
      %Tenancy{}

      iex> get_tenancy!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tenancy!(id), do: Tenancy |> Repo.get!(id) |> Repo.preload(:ledgers)

  @doc """
  Creates a tenancy.

  ## Examples

      iex> create_tenancy(%{field: value})
      {:ok, %Tenancy{}}

      iex> create_tenancy(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tenancy(attrs \\ %{}) do
    %Tenancy{}
    |> Tenancy.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tenancy.

  ## Examples

      iex> update_tenancy(tenancy, %{field: new_value})
      {:ok, %Tenancy{}}

      iex> update_tenancy(tenancy, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tenancy(%Tenancy{} = tenancy, attrs) do
    tenancy
    |> Tenancy.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tenancy.

  ## Examples

      iex> delete_tenancy(tenancy)
      {:ok, %Tenancy{}}

      iex> delete_tenancy(tenancy)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tenancy(%Tenancy{} = tenancy) do
    Repo.delete(tenancy)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tenancy changes.

  ## Examples

      iex> change_tenancy(tenancy)
      %Ecto.Changeset{data: %Tenancy{}}

  """
  def change_tenancy(%Tenancy{} = tenancy, attrs \\ %{}) do
    Tenancy.changeset(tenancy, attrs)
  end
end
