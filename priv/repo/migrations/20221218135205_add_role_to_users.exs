defmodule Rewards.Repo.Migrations.AddRoleToUsers do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :role, :string, default: "member"
    end
  end
end
