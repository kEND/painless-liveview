defmodule PainlessWeb.TenancyLive.Index do
  use PainlessWeb, :live_view

  alias Painless.LeasingAgent
  alias Painless.LeasingAgent.Tenancy

  @impl true
  def mount(params, _session, socket) do
    active = params["active"] || "true"

    {:ok,
     socket
     |> assign(active: active)
     |> stream(:tenancies, LeasingAgent.list_tenancies(active))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Tenancy")
    |> assign(:tenancy, LeasingAgent.get_tenancy!(id))
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
  def handle_info({PainlessWeb.TenancyLive.FormComponent, {:saved, tenancy}}, socket) do
    {:noreply, stream_insert(socket, :tenancies, tenancy)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    tenancy = LeasingAgent.get_tenancy!(id)
    {:ok, _} = LeasingAgent.delete_tenancy(tenancy)

    {:noreply, stream_delete(socket, :tenancies, tenancy)}
  end
end
