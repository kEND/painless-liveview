defmodule PainlessWeb.TenancyLive.Index do
  use PainlessWeb, :live_view

  alias Painless.Tenancies
  alias Painless.Tenancies.Tenancy

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:active, true)
      |> assign(:tenancies, list_tenancies(true))

    {:ok, socket}
  end

  def handle_event("toggle-active", _, socket) do
    show_active = socket.assigns.active

    socket =
      socket
      |> assign(:tenancies, list_tenancies(!show_active))
      |> assign(:active, !show_active)

    {:noreply, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Tenancy")
    |> assign(:tenancy, Tenancies.get_tenancy!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Tenancy")
    |> assign(:tenancy, %Tenancy{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tenancies")
    |> assign(:tenancy, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    tenancy = Tenancies.get_tenancy!(id)
    {:ok, _} = Tenancies.delete_tenancy(tenancy)

    {:noreply, assign(socket, :tenancies, list_tenancies(socket.assigns.active))}
  end

  defp list_tenancies(active) do
    Tenancies.list_tenancies(active)
  end
end
