defmodule TaskTrackerWeb.Router do
  use TaskTrackerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :get_current_user
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  def get_current_user(conn, _params) do
    user_id = get_session(conn, :user_id)
    user = TaskTracker.Accounts.get_user(user_id || -1)
    assign(conn, :current_user, user)
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TaskTrackerWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/board", PageController, :board
    post "/session", SessionController, :create
    delete "/session", SessionController, :delete
    resources "/users", UserController
    resources "/tasks", TaskController
  end

  scope "/api/v1", TaskTrackerWeb do
    pipe_through :api
    resources "/manages", ManageController, except: [:new, :edit]
    resources "/blocks", TimeBlockController, except: [:new, :edit]
  end

  # Other scopes may use custom stacks.
  # scope "/api", TaskTrackerWeb do
  #   pipe_through :api
  # end
end
