defmodule PainlessWeb.LedgerLive.Index do
  use PainlessWeb, :live_view

  alias Painless.Ledgers
  alias Painless.Ledgers.Ledger
  alias Painless.Tenancies

  @impl true
  def mount(%{"tenancy_id" => tenancy_id}, _session, socket) do
    {:ok,
     socket
     |> assign(:tenancy, Tenancies.get_tenancy!(tenancy_id))
     |> assign(:ledgers, list_ledgers(tenancy_id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Ledger")
    |> assign(:ledger, Ledgers.get_ledger!(id))
  end

  defp apply_action(socket, :new, %{"tenancy_id" => tenancy_id}) do
    socket
    |> assign(:page_title, "New Ledger")
    |> assign(:ledger, %Ledger{tenancy_id: tenancy_id})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Ledgers")
    |> assign(:ledger, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    ledger = Ledgers.get_ledger!(id)
    {:ok, _} = Ledgers.delete_ledger(ledger)

    {:noreply, assign(socket, :ledgers, list_ledgers(socket.assigns.tenancy.id))}
  end

  defp list_ledgers(tenancy_id) do
    Ledgers.list_ledgers(tenancy_id)
  end
end
