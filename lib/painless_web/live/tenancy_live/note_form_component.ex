defmodule PainlessWeb.TenancyLive.NoteFormComponent do
  use PainlessWeb, :live_component

  alias Painless.LeasingAgent

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Add a note for <%= @tenancy.name %> at <%= @tenancy.property %>.</:subtitle>
      </.header>

      <.simple_form for={@form} id="tenancy-note-form" phx-target={@myself} phx-change="validate" phx-submit="save">
        <.input field={@form[:body]} type="textarea" label="Note" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Note</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{note: note} = assigns, socket) do
    changeset = LeasingAgent.change_tenancy_note(note)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"tenancy_note" => note_params}, socket) do
    changeset =
      socket.assigns.note
      |> LeasingAgent.change_tenancy_note(note_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"tenancy_note" => note_params}, socket) do
    save_note(socket, socket.assigns.action, note_params)
  end

  defp save_note(socket, :edit_note, note_params) do
    case LeasingAgent.update_tenancy_note(socket.assigns.note, note_params) do
      {:ok, note} ->
        notify_parent({:saved, :edit, note})

        {:noreply,
         socket
         |> put_flash(:info, "Note updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_note(socket, :new_note, note_params) do
    case LeasingAgent.create_tenancy_note(socket.assigns.tenancy, socket.assigns.current_user, note_params) do
      {:ok, note} ->
        notify_parent({:saved, :new, note})

        {:noreply,
         socket
         |> put_flash(:info, "Note created successfully")
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
