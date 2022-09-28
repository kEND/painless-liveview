defmodule PainlessWeb.LedgerLive.FormComponent do
  use PainlessWeb, :live_component

  alias Painless.Ledgers

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage ledger records in your database.</:subtitle>
      </.header>

      <.simple_form :let={f} for={@changeset} id="ledger-form" phx-target={@myself} phx-change="validate" phx-submit="save">
        <.input field={{f, :name}} type="text" label="name" />
        <.input field={{f, :acct_type}} type="text" label="acct_type" />
        <.input field={{f, :balance}} type="text" label="balance" />
        <%= hidden_input(f, :tenancy_id) %>
        <:actions>
          <.button phx-disable-with="Saving...">Save Ledger</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{ledger: ledger} = assigns, socket) do
    changeset = Ledgers.change_ledger(ledger)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"ledger" => ledger_params}, socket) do
    changeset =
      socket.assigns.ledger
      |> Ledgers.change_ledger(ledger_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"ledger" => ledger_params}, socket) do
    save_ledger(socket, socket.assigns.action, ledger_params)
  end

  defp save_ledger(socket, :edit, ledger_params) do
    case Ledgers.update_ledger(socket.assigns.ledger, ledger_params) do
      {:ok, _ledger} ->
        {:noreply,
         socket
         |> put_flash(:info, "Ledger updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_ledger(socket, :new, ledger_params) do
    case Ledgers.create_ledger(ledger_params) do
      {:ok, _ledger} ->
        {:noreply,
         socket
         |> put_flash(:info, "Ledger created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
