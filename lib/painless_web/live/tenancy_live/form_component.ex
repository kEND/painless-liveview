defmodule PainlessWeb.TenancyLive.FormComponent do
  use PainlessWeb, :live_component

  alias Painless.Tenancies

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage tenancy records in your database.</:subtitle>
      </.header>

      <.simple_form :let={f} for={@changeset} id="tenancy-form" phx-target={@myself} phx-change="validate" phx-submit="save">
        <.input field={{f, :name}} type="text" label="name" />
        <.input field={{f, :property}} type="text" label="property" />
        <.input field={{f, :notes}} type="text" label="notes" />
        <.input field={{f, :rent}} type="text" label="rent" />
        <.input field={{f, :late_fee}} type="text" label="late_fee" />
        <.input field={{f, :balance}} type="text" label="balance" />
        <label phx-feedback-for="tenancy[:active]" class="flex items-center gap-4 text-sm leading-6 text-zinc-600">
          <%= checkbox(f, :active) %> Is active?
        </label>
        <.input field={{f, :rent_day_of_month}} type="number" label="rent_day_of_month" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Tenancy</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{tenancy: tenancy} = assigns, socket) do
    changeset = Tenancies.change_tenancy(tenancy)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"tenancy" => tenancy_params}, socket) do
    changeset =
      socket.assigns.tenancy
      |> Tenancies.change_tenancy(tenancy_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"tenancy" => tenancy_params}, socket) do
    save_tenancy(socket, socket.assigns.action, tenancy_params)
  end

  defp save_tenancy(socket, :edit, tenancy_params) do
    case Tenancies.update_tenancy(socket.assigns.tenancy, tenancy_params) do
      {:ok, _tenancy} ->
        {:noreply,
         socket
         |> put_flash(:info, "Tenancy updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_tenancy(socket, :new, tenancy_params) do
    case Tenancies.create_tenancy(tenancy_params) do
      {:ok, _tenancy} ->
        {:noreply,
         socket
         |> put_flash(:info, "Tenancy created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
