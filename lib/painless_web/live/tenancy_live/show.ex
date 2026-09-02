defmodule PainlessWeb.TenancyLive.Show do
  use PainlessWeb, :live_view

  alias Painless.LeasingAgent
  alias Painless.LeasingAgent.TenancyNote

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok, stream(socket, :tenancy_notes, LeasingAgent.list_tenancy_notes(id))}
  end

  @impl true
  def handle_params(params, _, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :show, %{"id" => id}) do
    socket
    |> assign(:page_title, "Show Tenancy")
    |> assign(:tenancy, LeasingAgent.get_tenancy!(id))
    |> assign(:note, nil)
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Tenancy")
    |> assign(:tenancy, LeasingAgent.get_tenancy!(id))
    |> assign(:note, nil)
  end

  defp apply_action(socket, :new_note, %{"id" => id}) do
    socket
    |> assign(:page_title, "New Note")
    |> assign(:tenancy, LeasingAgent.get_tenancy!(id))
    |> assign(:note, %TenancyNote{noted_at: TenancyNote.now()})
  end

  defp apply_action(socket, :edit_note, %{"id" => id, "note_id" => note_id}) do
    tenancy = LeasingAgent.get_tenancy!(id)
    note = LeasingAgent.get_tenancy_note!(tenancy.id, note_id)

    socket
    |> assign(:page_title, "Edit Note")
    |> assign(:tenancy, tenancy)
    |> assign(:note, note)
  end

  @impl true
  def handle_info({PainlessWeb.TenancyLive.NoteFormComponent, {:saved, _action, _note}}, socket) do
    notes = LeasingAgent.list_tenancy_notes(socket.assigns.tenancy.id)
    {:noreply, stream(socket, :tenancy_notes, notes, reset: true)}
  end

  @impl true
  def handle_event("delete_note", %{"id" => id}, socket) do
    note = LeasingAgent.get_tenancy_note!(socket.assigns.tenancy.id, id)
    {:ok, _} = LeasingAgent.delete_tenancy_note(note)

    {:noreply, stream_delete(socket, :tenancy_notes, note)}
  end

  defp format_note_date(%NaiveDateTime{} = datetime) do
    Calendar.strftime(datetime, "%m/%d/%Y")
  end

  defp format_note_author(%{email: email}) when is_binary(email) do
    String.slice(email, 0, 10)
  end

  defp note_edited?(%{inserted_at: inserted_at, updated_at: updated_at}) do
    NaiveDateTime.compare(updated_at, inserted_at) == :gt
  end
end
