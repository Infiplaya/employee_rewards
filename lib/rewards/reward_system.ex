defmodule Rewards.RewardSystem do
  @moduledoc """
  The RewardSystem context.
  """

  import Ecto.Query, warn: false
  alias Rewards.Repo
  alias Rewards.Accounts

  alias Rewards.RewardSystem.Reward

  @doc """
  Returns the list of rewards.

  ## Examples

      iex> list_rewards()
      [%Reward{}, ...]

  """
  def list_rewards_this_month do
    today = Date.utc_today()
    query = from(r in Reward, where: fragment("date_part('month', ?)", r.inserted_at) == ^today.month)
    Repo.all(query)
  end

  def list_rewards do
    Repo.all(Reward)
  end

  def list_user_rewards(%Accounts.User{} = user) do
    Reward
    |> user_rewards_query(user)
    |> Repo.all()
  end

  def get_user_reward!(%Accounts.User{} = user, id) do
    Reward
    |> user_rewards_query(user)
    |> Repo.get!(id)
  end

  defp user_rewards_query(query, %Accounts.User{id: user_id}) do
    from(r in query, where: r.user_id == ^user_id)
  end

  @doc """
  Gets a single reward.

  Raises `Ecto.NoResultsError` if the Reward does not exist.

  ## Examples

      iex> get_reward!(123)
      %Reward{}

      iex> get_reward!(456)
      ** (Ecto.NoResultsError)

  """
  def get_reward!(id), do: Repo.get!(Reward, id)

  @doc """
  Creates a reward.

  ## Examples

      iex> create_reward(%{field: value})
      {:ok, %Reward{}}

      iex> create_reward(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reward(%Accounts.User{} = user, attrs \\ %{}) do
    %Reward{}
    |> Reward.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Updates a reward.

  ## Examples

      iex> update_reward(reward, %{field: new_value})
      {:ok, %Reward{}}

      iex> update_reward(reward, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reward(%Reward{} = reward, attrs) do
    reward
    |> Reward.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a reward.

  ## Examples

      iex> delete_reward(reward)
      {:ok, %Reward{}}

      iex> delete_reward(reward)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reward(%Reward{} = reward) do
    Repo.delete(reward)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reward changes.

  ## Examples

      iex> change_reward(reward)
      %Ecto.Changeset{data: %Reward{}}

  """
  def change_reward(%Reward{} = reward, attrs \\ %{}) do
    Reward.changeset(reward, attrs)
  end
end
