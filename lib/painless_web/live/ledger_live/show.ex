defmodule PainlessWeb.LedgerLive.Show do
  use PainlessWeb, :live_view

  alias Painless.Ledgers
  alias Painless.Tenancies

  @impl true
  def mount(params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id, "tenancy_id" => tenancy_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:ledger, Ledgers.get_ledger!(id))
     |> assign(:tenancy, Tenancies.get_tenancy!(tenancy_id))}
  end

  defp page_title(:show), do: "Show Ledger"
  defp page_title(:edit), do: "Edit Ledger"
end
