defmodule Painless.Bookkeeper.RecurringEntries do
  use GenServer

  alias Painless.Bookkeeper

  @eleven_hours 39_600_000

  def start_link(arg), do: GenServer.start_link(__MODULE__, arg, name: __MODULE__)

  def init(init_arg) do
    schedule()
    {:ok, init_arg}
  end

  def schedule, do: Process.send_after(self(), :maybe_create_entries, @eleven_hours)

  def handle_info(:maybe_create_entries, state) do
    Bookkeeper.maybe_create_recurring_entries()
    |> IO.puts()
    schedule()
    {:noreply, state}
  end
end
