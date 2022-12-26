defmodule Rewards.Repo.Migrations.PointsConstraints do
  use Ecto.Migration

  def change do
    create constraint("rewards", "positive_points", check: "points > 0")
  end
end
