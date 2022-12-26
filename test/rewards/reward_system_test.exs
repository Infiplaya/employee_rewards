defmodule Rewards.RewardSystemTest do
  use Rewards.DataCase

  alias Rewards.RewardSystem

  describe "rewards" do
    alias Rewards.RewardSystem.Reward

    import Rewards.RewardSystemFixtures

    @invalid_attrs %{description: nil, points: nil, recipient_id: nil}

    test "list_rewards/0 returns all rewards" do
      reward = reward_fixture()
      assert RewardSystem.list_rewards() == [reward]
    end

    test "get_reward!/1 returns the reward with given id" do
      reward = reward_fixture()
      assert RewardSystem.get_reward!(reward.id) == reward
    end

    test "create_reward/1 with valid data creates a reward" do
      valid_attrs = %{description: "some description", points: 42, recipient_id: 42}

      assert {:ok, %Reward{} = reward} = RewardSystem.create_reward(valid_attrs)
      assert reward.description == "some description"
      assert reward.points == 42
      assert reward.recipient_id == 42
    end

    test "create_reward/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RewardSystem.create_reward(@invalid_attrs)
    end

    test "update_reward/2 with valid data updates the reward" do
      reward = reward_fixture()
      update_attrs = %{description: "some updated description", points: 43, recipient_id: 43}

      assert {:ok, %Reward{} = reward} = RewardSystem.update_reward(reward, update_attrs)
      assert reward.description == "some updated description"
      assert reward.points == 43
      assert reward.recipient_id == 43
    end

    test "update_reward/2 with invalid data returns error changeset" do
      reward = reward_fixture()
      assert {:error, %Ecto.Changeset{}} = RewardSystem.update_reward(reward, @invalid_attrs)
      assert reward == RewardSystem.get_reward!(reward.id)
    end

    test "delete_reward/1 deletes the reward" do
      reward = reward_fixture()
      assert {:ok, %Reward{}} = RewardSystem.delete_reward(reward)
      assert_raise Ecto.NoResultsError, fn -> RewardSystem.get_reward!(reward.id) end
    end

    test "change_reward/1 returns a reward changeset" do
      reward = reward_fixture()
      assert %Ecto.Changeset{} = RewardSystem.change_reward(reward)
    end
  end
end
