defmodule PainlessWeb.TenancyLive.FormComponent do
  use PainlessWeb, :live_component

  alias Painless.LeasingAgent

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage tenancy records in your database.</:subtitle>
      </.header>

      <.simple_form for={@form} id="tenancy-form" phx-target={@myself} phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:property]} type="text" label="Property" />
        <.input field={@form[:notes]} type="textarea" label="Notes" />
        <.input field={@form[:active]} type="checkbox" label="Active" />
        <.input field={@form[:recurring]} type="checkbox" label="Recurring" />
        <.input field={@form[:recurring_description]} type="textarea" label="Recurring description" />
        <.input field={@form[:late_fee]} type="text" label="Late fee" />
        <.input field={@form[:rent]} type="text" label="Rent" />
        <.input field={@form[:rent_day_of_month]} type="number" label="Rent day of month" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Tenancy</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{tenancy: tenancy} = assigns, socket) do
    changeset = LeasingAgent.change_tenancy(tenancy)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"tenancy" => tenancy_params}, socket) do
    changeset =
      socket.assigns.tenancy
      |> LeasingAgent.change_tenancy(tenancy_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"tenancy" => tenancy_params}, socket) do
    save_tenancy(socket, socket.assigns.action, tenancy_params)
  end

  defp save_tenancy(socket, :edit, tenancy_params) do
    case LeasingAgent.update_tenancy(socket.assigns.tenancy, tenancy_params) do
      {:ok, tenancy} ->
        notify_parent({:saved, tenancy})

        {:noreply,
         socket
         |> put_flash(:info, "Tenancy updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_tenancy(socket, :new, tenancy_params) do
    case LeasingAgent.create_tenancy(tenancy_params) do
      {:ok, tenancy} ->
        notify_parent({:saved, tenancy})

        {:noreply,
         socket
         |> put_flash(:info, "Tenancy created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
