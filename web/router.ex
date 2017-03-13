defmodule Bugoverflow.Router do
  use Bugoverflow.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Bugoverflow.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Bugoverflow do
    pipe_through :browser # Use the default browser stack

    get "/", ArticleController, :index

    resources "/articles", ArticleController do
      resources "/comments", CommentController, only: [:create]
    end
  end

  scope "/auth", Bugoverflow do
    pipe_through :browser

    get "/signout", AuthController, :signout
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end
  # Other scopes may use custom stacks.
  # scope "/api", Bugoverflow do
  #   pipe_through :api
  # end
end
