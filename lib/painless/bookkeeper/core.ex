defmodule Painless.Bookkeeper.Core do
  import Ecto.Query, warn: false

  alias Painless.Bookkeeper.Entry
  alias Painless.LeasingAgent.Tenancy
  alias Painless.Repo

  def entries(%Tenancy{} = tenancy) do
    Entry
    |> where([e], e.tenancy_id == ^tenancy.id)
    |> order_by([e], desc: e.transaction_date)
    |> Repo.all()
  end

  def balance(%Tenancy{} = tenancy, at \\ NaiveDateTime.local_now()) do
    Entry
    |> where([e], e.tenancy_id == ^tenancy.id and e.transaction_date <= ^at)
    |> select([e], sum(e.amount))
    |> Repo.one()
  end

  def get_entry!(id) do
    Repo.get!(Entry, id)
  end

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
