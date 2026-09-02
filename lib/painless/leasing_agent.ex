defmodule Painless.LeasingAgent do
  import Ecto.Query, warn: false

  alias Painless.Accounts.User
  alias Painless.Bookkeeper.Entry
  alias Painless.LeasingAgent.Tenancy
  alias Painless.LeasingAgent.TenancyNote
  alias Painless.Repo

  @doc """
  Returns the list of tenancies.

  ## Examples

      iex> list_tenancies()
      [%Tenancy{}, ...]

  """
  def list_tenancies(active \\ true) do
    from(t in Tenancy, as: :tenancy)
    |> join(:left_lateral, [t], b in subquery(balance_query()), on: true)
    |> select_merge([t, b], %{balance: b.balance})
    |> where([t], t.active == ^active)
    |> order_by([t], asc: t.property, asc: t.name)
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
  def get_tenancy!(id) do
    from(t in Tenancy, as: :tenancy)
    |> where([t], t.id == ^id)
    |> join(:left_lateral, [t], b in subquery(balance_query()), on: true)
    |> select_merge([t, b], %{balance: b.balance})
    |> Repo.one!()
  end

  defp balance_query() do
    Entry
    |> select([e], %{balance: type(sum(e.amount), Money.Ecto.Type)})
    |> where([e, t], e.tenancy_id == parent_as(:tenancy).id)
    |> where([e, t], e.transaction_date < ago(1, "microsecond"))
    |> group_by([e], e.tenancy_id)
  end

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

  @doc """
  Returns the list of notes for a tenancy, newest first.
  """
  def list_tenancy_notes(tenancy_id) do
    TenancyNote
    |> where([n], n.tenancy_id == ^tenancy_id)
    |> order_by([n], desc: n.noted_at, desc: n.id)
    |> preload(:user)
    |> Repo.all()
  end

  @doc """
  Gets a single tenancy note.

  Raises `Ecto.NoResultsError` if the note does not exist.
  """
  def get_tenancy_note!(id) do
    TenancyNote
    |> Repo.get!(id)
    |> Repo.preload(:user)
  end

  def get_tenancy_note!(tenancy_id, id) do
    TenancyNote
    |> where([n], n.tenancy_id == ^tenancy_id and n.id == ^id)
    |> Repo.one!()
    |> Repo.preload(:user)
  end

  @doc """
  Creates a tenancy note authored by the given user.
  """
  def create_tenancy_note(%Tenancy{} = tenancy, %User{} = user, attrs \\ %{}) do
    %TenancyNote{tenancy_id: tenancy.id, user_id: user.id}
    |> TenancyNote.changeset(attrs)
    |> Repo.insert()
    |> preload_note_user()
  end

  @doc """
  Updates a tenancy note. Authorship is unchanged.
  """
  def update_tenancy_note(%TenancyNote{} = tenancy_note, attrs) do
    tenancy_note
    |> TenancyNote.changeset(attrs)
    |> Repo.update()
    |> preload_note_user()
  end

  @doc """
  Deletes a tenancy note.
  """
  def delete_tenancy_note(%TenancyNote{} = tenancy_note) do
    Repo.delete(tenancy_note)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tenancy note changes.
  """
  def change_tenancy_note(%TenancyNote{} = tenancy_note, attrs \\ %{}) do
    TenancyNote.changeset(tenancy_note, attrs)
  end

  defp preload_note_user({:ok, tenancy_note}), do: {:ok, Repo.preload(tenancy_note, :user, force: true)}
  defp preload_note_user(error), do: error
end
