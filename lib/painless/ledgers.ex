defmodule Painless.Ledgers do
  @moduledoc """
  The Ledgers context.
  """

  import Ecto.Query, warn: false
  alias Painless.Repo

  alias Painless.Ledgers.Ledger

  @doc """
  Returns the list of ledgers.

  ## Examples

      iex> list_ledgers()
      [%Ledger{}, ...]

  """
  def list_ledgers(tenancy_id) do
    Ledger
    |> where([l], l.tenancy_id == ^tenancy_id)
    |> Repo.all()
  end

  @doc """
  Gets a single ledger.

  Raises `Ecto.NoResultsError` if the Ledger does not exist.

  ## Examples

      iex> get_ledger!(123)
      %Ledger{}

      iex> get_ledger!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ledger!(id), do: Repo.get!(Ledger, id)

  @doc """
  Creates a ledger.

  ## Examples

      iex> create_ledger(%{field: value})
      {:ok, %Ledger{}}

      iex> create_ledger(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ledger(attrs \\ %{}) do
    %Ledger{}
    |> Ledger.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ledger.

  ## Examples

      iex> update_ledger(ledger, %{field: new_value})
      {:ok, %Ledger{}}

      iex> update_ledger(ledger, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ledger(%Ledger{} = ledger, attrs) do
    ledger
    |> Ledger.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ledger.

  ## Examples

      iex> delete_ledger(ledger)
      {:ok, %Ledger{}}

      iex> delete_ledger(ledger)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ledger(%Ledger{} = ledger) do
    Repo.delete(ledger)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ledger changes.

  ## Examples

      iex> change_ledger(ledger)
      %Ecto.Changeset{data: %Ledger{}}

  """
  def change_ledger(%Ledger{} = ledger, attrs \\ %{}) do
    Ledger.changeset(ledger, attrs)
  end

  alias Painless.Ledgers.Entry

  @doc """
  Returns the list of entries.

  ## Examples

      iex> list_entries()
      [%Entry{}, ...]

  """
  def list_entries(ledger_id) do
    Entry
    |> where([e], e.ledger_id == ^ledger_id)
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
  def get_entry!(id), do: Entry |> Repo.get!(id) |> Repo.preload(ledger: [:tenancy])

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

  def maybe_add_expected_rents(active_tenancies) do
    active_tenancies = Repo.preload(active_tenancies, :ledgers)

    ledger_ids =
      active_tenancies
      |> Enum.map(fn %{ledgers: ledgers} ->
        ledger = Enum.find(ledgers, &(&1.acct_type == "Receivable"))
        ledger.id
      end)

    most_recent_expected_rent_beginning_of_month =
      Entry
      |> where([e], e.ledger_id in ^ledger_ids)
      |> select([e], max(e.transaction_date))
      |> Repo.one()
      |> Date.beginning_of_month()

    current_beginning_of_month =
      Date.utc_today()
      |> Date.beginning_of_month()

    if Date.diff(current_beginning_of_month, most_recent_expected_rent_beginning_of_month) > 0 do
      find_or_create_expected_rent(active_tenancies)
    end
  end

  defp find_or_create_expected_rent(active_tenancies) do
    Enum.map(this_and_prior_three_months(), fn date ->
      month_name = Calendar.strftime(date, "%B")

      active_tenancies
      |> Enum.map(fn %{ledgers: ledgers, rent_day_of_month: rent_day_of_month} = tenancy ->
        ledger = Enum.find(ledgers, &(&1.acct_type == "Receivable"))
        {year, month, _day} = Date.to_erl(date)

        %{
          ledger_id: ledger.id,
          amount: tenancy.rent,
          description: "Rent Due " <> month_name,
          transaction_date: Date.from_erl!({year, month, rent_day_of_month})
        }
      end)
    end)
    |> List.flatten()
    |> Enum.filter(fn %{ledger_id: ledger_id, description: description, transaction_date: date} ->
      is_nil(entry_by_ledger_id_description_and_date(ledger_id, description, date))
    end)
    |> Enum.each(&create_entry(&1))
  end

  defp this_and_prior_three_months do
    Enum.reduce(1..3, [Date.utc_today() |> Date.beginning_of_month()], fn _nth_time, list_of_months ->
      first_of_last_month =
        hd(list_of_months)
        |> Date.add(-1)
        |> Date.beginning_of_month()

      [first_of_last_month | list_of_months]
    end)
  end

  defp entry_by_ledger_id_description_and_date(ledger_id, description, date) do
    Entry
    |> where(ledger_id: ^ledger_id, description: ^description, transaction_date: ^date)
    |> Repo.one()
  end
end
