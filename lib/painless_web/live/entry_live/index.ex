defmodule PainlessWeb.EntryLive.Index do
  use PainlessWeb, :live_view

  alias Painless.Bookkeeper
  alias Painless.Bookkeeper.Entry
  alias Painless.LeasingAgent

  @impl true
  def mount(params, _session, socket) do
    tenancy = LeasingAgent.get_tenancy!(params["tenancy_id"])

    {:ok,
      socket
      |> assign(tenancy: tenancy)
      |> stream(:entries, Bookkeeper.list_entries(tenancy.id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Entry")
    |> assign(:entry, Bookkeeper.get_entry!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Entry")
    |> assign(:entry, %Entry{transaction_date: Date.utc_today()})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Entries")
    |> assign(:entry, nil)
  end

  @impl true
  def handle_info({PainlessWeb.EntryLive.FormComponent, {:saved, entry}}, socket) do
    {:noreply, stream_insert(socket, :entries, entry, at: 0)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    entry = Bookkeeper.get_entry!(id)
    {:ok, _} = Bookkeeper.delete_entry(entry)

    {:noreply, stream_delete(socket, :entries, entry)}
  end

  def display_income({id, entry}) do
    assigns = %{}

    transaction_type =
      if entry.transaction_type == "income" do
        ~H"""
        <.icon name="hero-banknotes" />
        """
      end

    {id, Map.merge(entry, %{transaction_type: transaction_type})}
  end

end
