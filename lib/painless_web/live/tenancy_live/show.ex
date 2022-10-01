defmodule PainlessWeb.TenancyLive.Show do
  use PainlessWeb, :live_view

  alias Painless.Tenancies
  alias Painless.Ledgers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket, temporary_assigns: [entries: []]}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    tenancy =
      id
      |> Tenancies.get_tenancy!()
      |> Tenancies.apply_entries_balance()

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:tenancy, tenancy)}
  end

  @impl true
  def handle_event("delete-entry", %{"id" => id}, socket) do
    entry = Ledgers.get_entry!(id)
    {:ok, _} = Ledgers.delete_entry(entry)

    tenancy =
      socket.assigns.tenancy
      |> Tenancies.apply_entries_balance()

    {:noreply,
     socket
     |> assign(:entries, Tenancies.list_combined_entries(socket.assigns.tenancy.id, 20))
     |> assign(:tenancy, tenancy)}
  end

  defp page_title(:show), do: "Show Tenancy"
  defp page_title(:edit), do: "Edit Tenancy"
end
