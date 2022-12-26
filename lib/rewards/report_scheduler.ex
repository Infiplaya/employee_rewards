defmodule MyApp.ReportScheduler do
  alias Rewards.RewardSystem


  def start_scheduler do
    Task.start_link(fn -> schedule_task() end)
  end

  defp schedule_task do
    RewardSystem.list_rewards_this_month()
    :timer.sleep(30_000_000)
    schedule_task()
  end
end
