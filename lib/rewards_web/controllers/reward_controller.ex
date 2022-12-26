defmodule RewardsWeb.RewardController do
  use RewardsWeb, :controller

  alias Rewards.Accounts
  alias Rewards.RewardSystem
  alias Rewards.RewardSystem.Reward
  alias Rewards.Repo

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, current_user) do
    rewards = RewardSystem.list_user_rewards(current_user)
    render(conn, "index.html", rewards: rewards)
  end

  def new(conn, _params, current_user) do
    users = Rewards.Accounts.list_users()
    other_users = Enum.reject(users, fn user -> user == current_user end)
    changeset = RewardSystem.change_reward(%Reward{})
    render(conn, "new.html", changeset: changeset, other_users: other_users)
  end

  def create(conn, %{"reward" => reward_params}, current_user) do
    # Get all users
    users = Rewards.Accounts.list_users()
    other_users = Enum.reject(users, fn user -> user == current_user end)

    case RewardSystem.create_reward(current_user, reward_params) do
      {:ok, reward} ->
        %{"description" => _desc, "points" => points, "recipient_email" => email} = reward_params
        points = Integer.parse(points)
        {points, ""} = points

        if current_user.points >= points do

          ## Update current user points
          current_user
          |> Ecto.Changeset.change(points: current_user.points - points)
          |> Repo.update()

          ## Update recipient points
          recipient = Rewards.Accounts.get_user_by_email(email)

          recipient
          |> Ecto.Changeset.change(points: recipient.points + points)
          |> Repo.update()

          Accounts.UserNotifier.deliver(recipient.email, "New reward", "You received new reward!");

          conn
          |> put_flash(:info, "Reward created successfully.")
          |> redirect(to: Routes.reward_path(conn, :show, reward))
        else
          conn
          |> put_flash(:error, "You do not have enough points to create this reward.")
          |> redirect(to: Routes.reward_path(conn, :new))
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, users: users, other_users: other_users)
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    reward = RewardSystem.get_user_reward!(current_user, id)
    render(conn, "show.html", reward: reward)
  end


  def delete(conn, %{"id" => id}, current_user) do
    reward = RewardSystem.get_user_reward!(current_user, id)
    {:ok, _reward} = RewardSystem.delete_reward(reward)

    conn
    |> put_flash(:info, "Reward deleted successfully.")
    |> redirect(to: Routes.reward_path(conn, :index))
  end
end
