defmodule Painless.Bookkeeper do
  import Ecto.Query, warn: false

  alias Painless.Bookkeeper.Entry
  alias Painless.LeasingAgent.Tenancy
  alias Painless.Repo

  @doc """
  Returns the list of entries.

  ## Examples

      iex> list_entries()
      [%Entry{}, ...]

  """
  def list_entries(tenancy_id) do
    Entry
    |> where([e], e.tenancy_id == ^tenancy_id)
    |> order_by([e], desc: e.transaction_date)
    |> Repo.all()
  end

  @doc """
  Gets a single entry.

  Raises `Ecto.NoResultsError` if the Entry does not exist.

  ## Examples

      iex> get_entry!(123)
      %Entry{}

      iex> get_entry!(456)
      ** (Ecto.NoResultsError)

  """
  def get_entry!(id), do: Repo.get!(Entry, id)

  @doc """
  Creates a entry.

  ## Examples

      iex> create_entry(%{field: value})
      {:ok, %Entry{}}

      iex> create_entry(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_entry(attrs \\ %{}) do
    %Entry{}
    |> Entry.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a entry.

  ## Examples

      iex> update_entry(entry, %{field: new_value})
      {:ok, %Entry{}}

      iex> update_entry(entry, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_entry(%Entry{} = entry, attrs) do
    entry
    |> Entry.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a entry.

  ## Examples

      iex> delete_entry(entry)
      {:ok, %Entry{}}

      iex> delete_entry(entry)
      {:error, %Ecto.Changeset{}}

  """
  def delete_entry(%Entry{} = entry) do
    Repo.delete(entry)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking entry changes.

  ## Examples

      iex> change_entry(entry)
      %Ecto.Changeset{data: %Entry{}}

  """
  def change_entry(%Entry{} = entry, attrs \\ %{}) do
    Entry.changeset(entry, attrs)
  end

  @doc """
  List recurring entries for active tenancies.
  """
  def list_recurring_entries_for_active_tenancies() do
    query = from e in Entry,
      join: t in Tenancy,
      on: e.tenancy_id == t.id,
      where: t.active == true,
      where: t.recurring == true,
      where: e.transaction_type == "receivable",
      where: ilike(e.description, fragment("(? || '%')", t.recurring_description)),
      where: fragment("? = make_date(date_part('year', now())::int, date_part('month', now())::int, ?)", e.transaction_date, t.rent_day_of_month),
      select: %{tenancy_id: e.tenancy_id, transaction_date: e.transaction_date, description: e.description, amount: e.amount}

    Repo.all(query)
  end

  def list_of_needed_recurring_entries_for_active_tenancies() do
    query = from t in Tenancy,
      where: t.active == true,
      where: t.recurring == true,
      select: %{tenancy_id: t.id, transaction_date: fragment("make_date( date_part('year', now())::int, date_part('month', now())::int, ?)", t.rent_day_of_month), description: fragment("? || ' ' || trim(to_char(now(), 'Month'))", t.recurring_description), amount: type(t.rent * -1, Money.Ecto.Amount.Type)}

    Repo.all(query)
  end

  def maybe_create_recurring_entries() do
    MapSet.new(list_of_needed_recurring_entries_for_active_tenancies())
    |> MapSet.difference(MapSet.new(list_recurring_entries_for_active_tenancies()))
    |> Enum.each(fn entry ->
      create_entry(Map.put(entry, :transaction_type, "receivable"))
    end)
  end
end
