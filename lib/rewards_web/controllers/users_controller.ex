defmodule RewardsWeb.UsersController do
  use RewardsWeb, :controller
  alias Rewards.Accounts
  alias Rewards.Accounts.User
  alias Rewards.Repo

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def edit(conn, %{"id" => user_id}) do
    user = Accounts.get_user!(user_id)
    changeset = User.changeset(user)

    render(conn, "edit.html", changeset: changeset, user: user)
  end

  def update(conn, %{"id" => user_id, "user" => user}) do
    old_user = Accounts.get_user!(user_id)
    changeset = User.changeset(old_user, user)

    case Repo.update(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User updated!")
        |> redirect(to: Routes.admin_path(conn, :index))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset, user: old_user)
    end
  end
end
