defmodule PainlessWeb.LeasingLive do
  use PainlessWeb, :live_view

  alias Painless.LeasingAgent

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-xxl">
      <.header class="text-center">
        <div :if={@show_active}>Active Tenancies</div>
        <div :if={!@show_active}>All Tenancies</div>
        <:subtitle>
          <div class="flex items-center justify-between w-1/3">
            <span>
              Show only active:
            </span>
            <span>
              <.input
                type="checkbox"
                name="show-active"
                checked={@show_active}
                value={@show_active}
                phx-click={JS.push("toggle_active")}
              />
            </span>
          </div>
        </:subtitle>
      </.header>

      <%!-- <pre><%= inspect(@tenancies, pretty: true) %></pre> --%>

      <.table id="tenancies" rows={@tenancies} row_click={fn tenancy -> JS.navigate(~p"/leasing/#{tenancy}/entries") end}>
        <:col :let={tenancy} label="id"><%= tenancy.id %></:col>
        <:col :let={tenancy} label="name"><%= tenancy.name %></:col>
        <:col :let={tenancy} label="property"><%= tenancy.property %></:col>
        <:col :let={tenancy} label="rent"><%= tenancy.rent %></:col>
        <:col :let={tenancy} label="balance"><%= tenancy.balance %></:col>
        <:action :let={tenancy}>
          <.link patch={~p"/leasing/#{tenancy}/entries/new"}>
            <.icon name="hero-banknotes" />
          </.link>
        </:action>
        <:action :let={tenancy}>
          <.link patch={~p"/leasing/#{tenancy}/entries"}>
            <.icon name="hero-queue-list" />
          </.link>
        </:action>
      </.table>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    tenancies = LeasingAgent.tenancies()

    {:ok,
     socket
     |> assign(show_active: true)
     |> assign(tenancies: tenancies)}
  end

  def handle_event("toggle_active", _, socket) do
    IO.inspect(socket.assigns.show_active)
    show_active = !socket.assigns.show_active

    {:noreply,
     socket
     |> assign(:show_active, show_active)
     |> assign(:tenancies, LeasingAgent.tenancies(show_active))}
  end
end
