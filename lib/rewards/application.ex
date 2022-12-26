defmodule Rewards.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Rewards.Repo,
      # Start the Telemetry supervisor
      RewardsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Rewards.PubSub},
      # Start the Endpoint (http/https)
      RewardsWeb.Endpoint,
      # Reset points
      Rewards.ResetPoints
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Rewards.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RewardsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
