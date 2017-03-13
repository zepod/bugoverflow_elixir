defmodule Bugoverflow.CommentController do
  use Bugoverflow.Web, :controller

  alias Bugoverflow.Article
  plug Bugoverflow.Plugs.RequireAuth when action in [ :create ]

  def create(%{assigns: %{user: user}} = conn, %{"comment" => comment_params, "article_id" => article_id}) do
    article = Repo.get(Article, article_id)
    comment_changeset = Ecto.build_assoc(article, :comments, body: comment_params["body"])
    comment_changeset = Ecto.build_assoc(user, :comments, comment_changeset)

    Repo.insert(comment_changeset)

    conn
    |> put_flash(:info, "Comment posted!")
    |> redirect(to: article_path(conn, :show, article))
  end

end
