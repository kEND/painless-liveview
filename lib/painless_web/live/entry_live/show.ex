defmodule PainlessWeb.EntryLive.Show do
  use PainlessWeb, :live_view

  alias Painless.Ledgers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id, "ledger_id" => ledger_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:entry, Ledgers.get_entry!(id))
     |> assign(:ledger, Ledgers.get_ledger!(ledger_id))}
  end

  defp page_title(:show), do: "Show Entry"
  defp page_title(:edit), do: "Edit Entry"
end
