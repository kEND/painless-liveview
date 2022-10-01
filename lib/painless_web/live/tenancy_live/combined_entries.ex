defmodule PainlessWeb.TenancyLive.CombinedEntries do
  use PainlessWeb, :live_component

  alias Painless.Tenancies

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.table
        id="entries"
        rows={@entries}
        row_click={&JS.navigate(~p"/tenancies/#{@tenancy}/ledgers/#{&1.ledger_id}/entries/#{&1}")}
      >
        <:col :let={entry} label="Description"><%= entry.description %></:col>
        <:col :let={entry} label="Charge"><%= entry.charge %></:col>
        <:col :let={entry} label="Payment"><%= entry.payment %></:col>
        <:col :let={entry} label="Transaction date"><%= entry.transaction_date %></:col>
        <:action :let={entry}>
          <div class="sr-only">
            <.link navigate={~p"/tenancies/#{@tenancy}/ledgers/#{entry.ledger_id}/entries/#{entry}"}>Show</.link>
          </div>
          <.link patch={~p"/tenancies/#{@tenancy}/ledgers/#{entry.ledger_id}/entries/#{entry}/edit"}>Edit</.link>
        </:action>
        <:action :let={entry}>
          <.link phx-click={JS.push("delete-entry", value: %{id: entry.id})} data-confirm="Are you sure?">
            Delete
          </.link>
        </:action>
      </.table>
    </div>
    """
  end

  @impl true
  def update(%{tenancy: tenancy} = assigns, socket) do
    entries = Tenancies.list_combined_entries(tenancy.id, 20)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:entries, entries)}
  end
end
