defmodule Rewards.ResetPoints do
  use GenServer
  alias Rewards.Accounts.User
  alias Rewards.Repo

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work() # Schedule work to be performed at some point
    {:ok, state}
  end

  def handle_info(:work, state) do
    reset_points()
    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 30 * 24 * 60 * 60 * 1000) # Run it every month
  end

  def reset_points() do
    User
    |> Repo.all()
    |> Enum.map(fn user -> user |> User.changeset(%{points: 50}) |> Repo.update() end)
  end
end
