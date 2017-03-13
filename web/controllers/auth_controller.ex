defmodule Bugoverflow.AuthController do
  use Bugoverflow.Web, :controller
  plug Ueberauth

  alias Bugoverflow.User

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do

    user_params = %{
      email: auth.info.email,
      provider: "github",
      token: auth.credentials.token,
      avatar_url: auth.info.urls.avatar_url,
      name: auth.info.nickname
    }
    changeset = User.changeset(%User{}, user_params)

    sign_in(conn, changeset)
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: article_path(conn, :index))
  end

  defp sign_in(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully logged in")
        |> put_session(:user_id, user.id)
        |> redirect(to: article_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: article_path(conn, :index))
    end
  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end
end
