defmodule TaskTrackerWeb.PageController do
  use TaskTrackerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def board(conn, _params) do
    #tasks = TaskTracker.Social.list_tasks()
    tasks = Enum.reverse(TaskTracker.Social.board_posts_for(conn.assigns[:current_user]))
    changeset = TaskTracker.Social.change_task(%TaskTracker.Social.Task{})

    render conn, "board.html", tasks: tasks, changeset: changeset
  end
end
