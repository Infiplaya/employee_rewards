defmodule Rewards.RewardSystem.Reward do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rewards" do
    field :description, :string
    field :points, :integer
    field :recipient_email, :string
    belongs_to :user, Rewards.Accounts.User

    timestamps()
  end

  @spec changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(reward, attrs) do
    reward
    |> cast(attrs, [:recipient_email, :points, :description])
    |> validate_required([:recipient_email, :points, :description])
    |> check_constraint(:points, name: :positive_points)
  end
end
