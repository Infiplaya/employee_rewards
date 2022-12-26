defmodule RewardsWeb.ReportController do
  use RewardsWeb, :controller

  alias Rewards.RewardSystem
  alias Rewards.RewardSystem.Reward

  def index(conn, _params) do
    rewards = RewardSystem.list_rewards_this_month()
    updated_rewards = Enum.map(rewards, fn
      %Reward{} = reward -> %Reward{reward | user: Rewards.Accounts.get_user!(reward.user_id)}
      user -> user
    end)
    render(conn, "index.html", rewards: updated_rewards)
  end

  def show(conn, %{"id" => id}) do
    reward = RewardSystem.get_reward!(id)
    render(conn, "show.html", reward: reward)
  end
end
