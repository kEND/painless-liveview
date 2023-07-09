defmodule Painless.Bookkeeper do
  import Ecto.Query, warn: false

  alias Painless.Bookkeeper.Core
  alias Painless.Bookkeeper.Entry
  alias Painless.LeasingAgent.Tenancy
  alias Painless.Repo

  def open(%Tenancy{} = tenancy) do
    %{tenancy | entries: Core.entries(tenancy), balance: balance(tenancy)}
  end

  # def balance(nil), do: Money.new(0)

  def balance(%Tenancy{} = tenancy, at \\ NaiveDateTime.local_now()) do
    Core.balance(tenancy, at)
  end

  # def get_entry!(id) do
  #   Core.get_entry!(id)
  # end

  # def change_entry(%Entry{} = entry, attrs \\ %{}) do
  #   Core.change_entry(entry, attrs)
  # end

  # def create_entry(attrs \\ %{}) do
  #   Core.create_entry(attrs)
  # end

  # def update_entry(%Entry{} = entry, attrs) do
  #   Core.update_entry(entry, attrs)
  # end

  # def delete_entry(%Entry{} = entry) do
  #   Core.delete_entry(entry)
  # end

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
end
