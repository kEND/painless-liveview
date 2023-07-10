defmodule PainlessWeb.EntryLive.Show do
  use PainlessWeb, :live_view

  alias Painless.Bookkeeper
  alias Painless.LeasingAgent

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id, "tenancy_id" => tenancy_id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:tenancy, LeasingAgent.get_tenancy!(tenancy_id))
     |> assign(:entry, Bookkeeper.get_entry!(id))}
  end

  defp page_title(:show), do: "Show Entry"
  defp page_title(:edit), do: "Edit Entry"
end
