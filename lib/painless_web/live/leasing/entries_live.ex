defmodule PainlessWeb.EntriesLive do
  use PainlessWeb, :live_view

  alias Painless.Bookkeeper
  alias Painless.LeasingAgent

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-xxl">
      <.header class="text-center">
        Account Entries for <%= @tenancy.name %>
        <:actions>
          <.link navigate={~p"/leasing"}>
            <.button>Active Tenancies</.button>
          </.link>
        </:actions>
        <:subtitle>
          currently leasing <%= @tenancy.property %>... Income: <.icon name="hero-banknotes" />
        </:subtitle>
      </.header>

      <%!-- <pre><%= inspect(@entries, pretty: true) %></pre> --%>

      <.table id="entries" rows={@streams.entries} row_item={&display_income/1} table_class="lg:w-full">
        <:col :let={{_id, entry}} label="Date"><%= entry.transaction_date %></:col>
        <:col :let={{_id, entry}} label="Amount"><%= entry.amount %></:col>
        <:col :let={{_id, entry}} label="--"><%= entry.transaction_type %></:col>
        <:col :let={{_id, entry}} label="Description"><%= entry.description %></:col>
      </.table>
    </div>
    """
  end

  def display_income({id, entry}) do
    assigns = %{}

    transaction_type =
      if entry.transaction_type == "income" do
        ~H"""
        <.icon name="hero-banknotes" />
        """
      end

    {id, Map.merge(entry, %{transaction_type: transaction_type})}
  end

  def mount(params, _session, socket) do
    tenancy = LeasingAgent.new(params).current_tenancy

    {:ok,
     socket
     |> assign(tenancy: tenancy)
     |> stream(:entries, Bookkeeper.entries(tenancy)), temporary_assigns: [tenancy: tenancy]}
  end
end
