defmodule PainlessWeb.LeasingLive do
  use PainlessWeb, :live_view

  alias Painless.LeasingAgent

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-xxl">
      <.header class="text-center">
        Active Tenancies
        <:subtitle>
          Just a listing for now...
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
    {:ok, assign(socket, tenancies: tenancies), temporary_assigns: [tenancies: tenancies]}
  end
end
