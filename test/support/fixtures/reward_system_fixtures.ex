defmodule Rewards.RewardSystemFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rewards.RewardSystem` context.
  """

  @doc """
  Generate a reward.
  """
  def reward_fixture(attrs \\ %{}) do
    {:ok, reward} =
      attrs
      |> Enum.into(%{
        description: "some description",
        points: 42,
        recipient_id: 42
      })
      |> Rewards.RewardSystem.create_reward()

    reward
  end
end
