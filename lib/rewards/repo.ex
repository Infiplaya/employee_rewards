defmodule Rewards.Repo do
  use Ecto.Repo,
    otp_app: :rewards,
    adapter: Ecto.Adapters.Postgres
end
