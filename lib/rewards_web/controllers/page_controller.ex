defmodule RewardsWeb.PageController do
  use RewardsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
