defmodule Rewards.Repo.Migrations.SwapIdToEmail do
  use Ecto.Migration

  def change do
    alter table("rewards") do
      remove :recipient_id
      add :recipient_email, :string
    end
  end
end
