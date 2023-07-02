defmodule PainlessWeb.EntriesLive do
  use PainlessWeb, :live_view

  alias Painless.Bookkeeper
  alias Painless.Bookkeeper.Entry
  alias Painless.LeasingAgent

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-xxl">
      <.header class="text-center">
        Account Entries for <%= @tenancy.name %>
        <:actions>
          <.link navigate={~p"/tenancies"}>
            <.button>Active Tenancies</.button>
          </.link>
          <.link patch={~p"/leasing/#{@tenancy}/entries/new"}>
            <.button>New Entry</.button>
          </.link>
        </:actions>
        <:subtitle>
          currently leasing <%= @tenancy.property %>... Income: <.icon name="hero-banknotes" />
        </:subtitle>
        <p>Balance: <%= @tenancy.balance %></p>
        <p class="text-sm">
          <%= @tenancy.notes %>
        </p>
      </.header>

      <%!-- <pre><%= inspect(@entries, pretty: true) %></pre> --%>

      <.table id="entries" rows={@streams.entries} row_item={&display_income/1} table_class="lg:w-full">
        <:col :let={{_id, entry}} label="Date"><%= entry.transaction_date %></:col>
        <:col :let={{_id, entry}} label="Amount"><%= entry.amount %></:col>
        <:col :let={{_id, entry}} label="--"><%= entry.transaction_type %></:col>
        <:col :let={{_id, entry}} label="Description"><%= entry.description %></:col>
        <:action :let={{_id, entry}}>
          <.link patch={~p"/leasing/#{@tenancy}/entries/#{entry}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, entry}}>
          <.link phx-click={JS.push("delete", value: %{id: entry.id}) |> hide("##{id}")} data-confirm="Are you sure?">
            Delete
          </.link>
        </:action>
      </.table>

      <.modal
        :if={@live_action in [:new, :edit]}
        id="entry-modal"
        show
        on_cancel={JS.patch(~p"/leasing/#{@tenancy}/entries")}
      >
        <.live_component
          module={PainlessWeb.Entries.FormComponent}
          id={@entry.id || :new}
          title={@page_title}
          action={@live_action}
          tenancy={@tenancy}
          entry={@entry}
          patch={~p"/leasing/#{@tenancy}/entries"}
        />
      </.modal>
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

  @impl true
  def mount(params, _session, socket) do
    %{entries: entries} = tenancy = LeasingAgent.new(params).current_tenancy |> Bookkeeper.open()

    {:ok,
     socket
     |> assign(tenancy: tenancy)
     |> stream(:entries, entries), temporary_assigns: [tenancy: tenancy]}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Entry")
    |> assign(:entry, Bookkeeper.get_entry!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Entry")
    |> assign(:entry, %Entry{transaction_date: Date.utc_today()})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Entries")
    |> assign(:entry, nil)
  end

  @impl true
  def handle_info({PainlessWeb.Entries.FormComponent, {:saved, entry}}, socket) do
    {:noreply, stream_insert(socket, :entries, entry)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    entry = Bookkeeper.get_entry!(id)
    {:ok, _} = Bookkeeper.delete_entry(entry)

    {:noreply, stream_delete(socket, :entries, entry)}
  end
end
