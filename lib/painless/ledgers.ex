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
end
