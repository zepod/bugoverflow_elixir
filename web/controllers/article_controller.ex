defmodule Bugoverflow.ArticleController do
  use Bugoverflow.Web, :controller

  alias Bugoverflow.Article
  alias Bugoverflow.Comment

  plug Bugoverflow.Plugs.RequireAuth when action in [
    :new, :create, :edit, :update, :delete
  ]
  plug :check_article_owner when action in [
    :update, :edit, :delete
  ]

  def index(conn, _params) do
    articles = Repo.all(Article)
    render(conn, "index.html", articles: articles)
  end

  def new(conn, _params) do
    changeset = Article.changeset(%Article{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"article" => article_params}) do
    changeset = conn.assigns.user
      |> build_assoc(:articles)
      |> Article.changeset(article_params)

    case Repo.insert(changeset) do
      {:ok, _article} ->
        conn
        |> put_flash(:info, "Article created successfully.")
        |> redirect(to: article_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    article = Repo.get!(Article, id) |> Repo.preload([comments: [:user]])
    IO.puts "//////"
    IO.inspect article
    IO.puts "//////"
    comment_changeset = Comment.changeset(%Comment{})
    render(conn, "show.html", article: article, comment_changeset: comment_changeset)
  end

  def edit(conn, %{"id" => id}) do
    article = Repo.get!(Article, id)
    changeset = Article.changeset(article)
    render(conn, "edit.html", article: article, changeset: changeset)
  end

  def update(conn, %{"id" => id, "article" => article_params}) do
    article = Repo.get!(Article, id)
    changeset = Article.changeset(article, article_params)

    case Repo.update(changeset) do
      {:ok, article} ->
        conn
        |> put_flash(:info, "Article updated successfully.")
        |> redirect(to: article_path(conn, :show, article))
      {:error, changeset} ->
        render(conn, "edit.html", article: article, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    article = Repo.get!(Article, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(article)

    conn
    |> put_flash(:info, "Article deleted successfully.")
    |> redirect(to: article_path(conn, :index))
  end

  defp check_article_owner(conn, _params) do
  %{params: %{"id" => article_id}} = conn

    if Repo.get(Article, article_id).user_id == conn.assigns.user.id do
      conn
    else
      conn
      |> put_flash(:error, "You cannot edit that")
      |> redirect(to: article_path(conn, :index))
      |> halt()
    end
  end
end
