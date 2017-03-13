defmodule Bugoverflow.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias Bugoverflow.Router.Helpers

  def init(_params) do
  end

  def call(conn, _params) do
    if conn.assigns[:user] do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in")
      |> redirect(to: Helpers.article_path(conn, :index))
      |> halt()
    end
  end
end
