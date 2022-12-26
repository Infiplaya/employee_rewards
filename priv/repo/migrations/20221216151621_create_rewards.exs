defmodule Rewards.Repo.Migrations.CreateRewards do
  use Ecto.Migration

  def change do
    create table(:rewards) do
      add :recipient_id, :integer
      add :points, :integer
      add :description, :text
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:rewards, [:user_id])
  end
end
