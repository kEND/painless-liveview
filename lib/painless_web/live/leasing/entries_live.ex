defmodule PainlessWeb.EntriesLive do
  use PainlessWeb, :live_view

  alias Painless.Bookkeeper
  alias Painless.LeasingAgent

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Account Entries for <%= @tenancy.name %>
        <:actions>
          <.link patch={~p"/leasing"}>
            <.button>Active Tenancies</.button>
          </.link>
        </:actions>
        <:subtitle>
          currently leasing <%= @tenancy.property %>... Income: <.icon name="hero-banknotes" />
        </:subtitle>
      </.header>

      <%!-- <pre><%= inspect(@entries, pretty: true) %></pre> --%>

      <.table id="entries" rows={@entries} row_item={&display_income/1}>
        <:col :let={entry} label="Date"><%= entry.transaction_date %></:col>
        <:col :let={entry} label="Amount"><%= entry.amount %></:col>
        <:col :let={entry} label="--"><%= entry.transaction_type %></:col>
        <:col :let={entry} label="Description"><%= entry.description %></:col>
      </.table>
    </div>
    """
  end

  def display_income(entry) do
    assigns = %{}

    transaction_type =
      if entry.transaction_type == "income" do
        ~H"""
        <.icon name="hero-banknotes" />
        """
      end

    Map.merge(entry, %{transaction_type: transaction_type})
  end

  def mount(params, _session, socket) do
    tenancy = LeasingAgent.new(params).current_tenancy
    entries = Bookkeeper.entries(tenancy)

    {:ok, assign(socket, tenancy: tenancy, entries: entries), temporary_assigns: [tenancy: tenancy, entries: entries]}
  end
end
