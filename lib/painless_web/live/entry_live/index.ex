defmodule PainlessWeb.EntryLive.Index do
  use PainlessWeb, :live_view

  alias Painless.Ledgers
  alias Painless.Ledgers.Entry

  @impl true
  def mount(%{"ledger_id" => ledger_id}, _session, socket) do
    {:ok,
     socket
     |> assign(:ledger, Ledgers.get_ledger!(ledger_id))
     |> assign(:entries, list_entries(ledger_id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Entry")
    |> assign(:entry, Ledgers.get_entry!(id))
  end

  defp apply_action(socket, :new, %{"ledger_id" => ledger_id}) do
    socket
    |> assign(:page_title, "New Entry")
    |> assign(:entry, %Entry{ledger_id: ledger_id})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Entries")
    |> assign(:entry, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    entry = Ledgers.get_entry!(id)
    {:ok, _} = Ledgers.delete_entry(entry)

    {:noreply, assign(socket, :entries, list_entries(socket.assigns.ledger.id))}
  end

  defp list_entries(ledger_id) do
    Ledgers.list_entries(ledger_id)
  end
end
