defmodule PainlessWeb.TenancyLive.Show do
  use PainlessWeb, :live_view

  alias Painless.LeasingAgent

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:tenancy, LeasingAgent.get_tenancy!(id))}
  end

  defp page_title(:show), do: "Show Tenancy"
  defp page_title(:edit), do: "Edit Tenancy"
end
