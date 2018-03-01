defmodule TaskTrackerWeb.TaskController do
  use TaskTrackerWeb, :controller

  alias TaskTracker.Social
  alias TaskTracker.Social.Task

  def index(conn, _params) do
    tasks = Social.list_tasks()
    managers = Social.all_managers()

    render(conn, "index.html", tasks: tasks, managers: managers)
  end

  def new(conn, _params) do
    changeset = Social.change_task(%Task{})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"task" => task_params}) do
    username = Map.get(task_params, "assigned_id")
    assigned_user = TaskTracker.Accounts.get_user_by_name(username)

    new_start = task_params["new_start_time"]
    |> Enum.into(%{}, fn{k, v} -> {k, String.to_integer(v)} end)
    new_end = task_params["new_end_time"]
    |> Enum.into(%{}, fn{k, v} -> {k, String.to_integer(v)} end)

    {:ok, start_time} = NaiveDateTime.new(new_start["year"], new_start["month"], new_start["day"],
      new_start["hour"], new_start["minute"], new_start["second"])
    {:ok, end_time} = NaiveDateTime.new(new_end["year"], new_end["month"], new_end["day"],
      new_end["hour"], new_end["minute"], new_end["second"])

    # checks for invalid end times
    if (NaiveDateTime.compare(start_time, end_time) == :gt) do
      conn
      |> put_flash(:error, "Invalid end time.")
      |> render("index.html", tasks: Social.list_tasks(), managers: Social.all_managers())
    else
      new_params = Map.put(task_params, "assigned_id", assigned_user.id)
      |> Map.put("new_start_time", start_time)
      |> Map.put("new_end_time", end_time)

      case Social.create_task(new_params) do
        {:ok, task} ->
          conn
          |> put_flash(:info, "Task created successfully.")
          |> redirect(to: task_path(conn, :show, task))
        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    task = Social.get_task!(id)
    blocks = Social.get_time_blocks_by_task_id(id)

    render(conn, "show.html", task: task, blocks: blocks)
  end

  def edit(conn, %{"id" => id}) do
    task = Social.get_task!(id)
    changeset = Social.change_task(task)
    blocks = Social.get_time_blocks_by_task_id(id)

    render(conn, "edit.html", task: task, changeset: changeset, blocks: blocks)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Social.get_task!(id)

    new_start = task_params["new_start_time"]
    |> Enum.into(%{}, fn{k, v} -> {k, String.to_integer(v)} end)
    new_end = task_params["new_end_time"]
    |> Enum.into(%{}, fn{k, v} -> {k, String.to_integer(v)} end)

    {:ok, start_time} = NaiveDateTime.new(new_start["year"], new_start["month"], new_start["day"],
      new_start["hour"], new_start["minute"], new_start["second"])
    {:ok, end_time} = NaiveDateTime.new(new_end["year"], new_end["month"], new_end["day"],
      new_end["hour"], new_end["minute"], new_end["second"])

    new_params = Map.put(task_params, "new_start_time", start_time)
    |> Map.put("new_end_time", end_time)

    case Social.update_task(task, new_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: task_path(conn, :show, task))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Social.get_task!(id)
    {:ok, _task} = Social.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: task_path(conn, :index))
  end
end
