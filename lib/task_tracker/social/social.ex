defmodule TaskTracker.Social do
  @moduledoc """
  The Social context.
  """

  import Ecto.Query, warn: false
  alias TaskTracker.Repo

  alias TaskTracker.Social.Task
  alias TaskTracker.Accounts.User
  alias TaskTracker.Social.TimeBlock

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    Repo.all(Task)
    |> Repo.preload(:user)
    |> Repo.preload(:assigned)
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id) do
    Repo.get!(Task, id)
    |> Repo.preload(:user)
    |> Repo.preload(:assigned)
  end

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    task_attrs = Map.drop(attrs, ["new_start_time", "new_end_time"])

    user = TaskTracker.Accounts.get_user!(Map.get(attrs, "user_id"))
    user_managers = get_underlings(user)
    |> Enum.map(&[&1.id])
    |> List.flatten()

    task = %Task{}
    |> Repo.preload(:user)
    |> Task.changeset(task_attrs)
    |> Repo.insert()

    start_time = attrs["new_start_time"]
    end_time = attrs["new_end_time"]
    {:ok, t} = task
    block_attrs = %{"start" => start_time,
                    "end" => end_time,
                    "task_id" => t.id}

    if (check_duplicates(t.id, start_time, end_time)), do: create_time_block(block_attrs)
    task
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task_attrs = Map.drop(attrs, ["start_time", "end_time", "new_start_time", "new_end_time"])
    IO.inspect(task_attrs)

    task = task
    |> Task.changeset(attrs)
    |> Repo.update()

    start_time = attrs["new_start_time"]
    end_time = attrs["new_end_time"]
    {:ok, t} = task
    block_attrs = %{"start" => start_time,
                    "end" => end_time,
                    "task_id" => t.id}

    if (check_duplicates(t.id, start_time, end_time)), do: create_time_block(block_attrs)
    task
  end

  defp check_duplicates(task_id, start_time, end_time) do
    same_blocks = Repo.all(TimeBlock)
    |> Enum.filter(fn(x) -> x.task_id == task_id and
        NaiveDateTime.compare(x.start, start_time) == :eq and
        NaiveDateTime.compare(x.end, start_time) == :eq end)
    |> Enum.empty?()
  end

  @doc """
  Deletes a Task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{source: %Task{}}

  """
  def change_task(%Task{} = task) do
    Task.changeset(task, %{})
  end

  alias TaskTracker.Social.Manage

  @doc """
  Returns the list of manages.

  ## Examples

      iex> list_manages()
      [%Manage{}, ...]

  """
  def list_manages do
    Repo.all(Manage)
  end

  @doc """
  Gets a single manage.

  Raises `Ecto.NoResultsError` if the Manage does not exist.

  ## Examples

      iex> get_manage!(123)
      %Manage{}

      iex> get_manage!(456)
      ** (Ecto.NoResultsError)

  """
  def get_manage!(id), do: Repo.get!(Manage, id)

  @doc """
  Creates a manage.

  ## Examples

      iex> create_manage(%{field: value})
      {:ok, %Manage{}}

      iex> create_manage(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_manage(attrs \\ %{}) do
    %Manage{}
    |> Manage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a manage.

  ## Examples

      iex> update_manage(manage, %{field: new_value})
      {:ok, %Manage{}}

      iex> update_manage(manage, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_manage(%Manage{} = manage, attrs) do
    manage
    |> Manage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Manage.

  ## Examples

      iex> delete_manage(manage)
      {:ok, %Manage{}}

      iex> delete_manage(manage)
      {:error, %Ecto.Changeset{}}

  """
  def delete_manage(%Manage{} = manage) do
    Repo.delete(manage)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking manage changes.

  ## Examples

      iex> change_manage(manage)
      %Ecto.Changeset{source: %Manage{}}

  """
  def change_manage(%Manage{} = manage) do
    Manage.changeset(manage, %{})
  end

  def manages_map_for(user_id) do
    Repo.all(from m in Manage,
             where: m.underling_id == ^user_id)
    |> Enum.map(&({&1.manager_id, &1.id}))
    |> Enum.into(%{})
  end

  def board_tasks_for(user) do
    user = Repo.preload(user, :managers)
    underlings_ids = [user.id | Enum.map(user.managers, &(&1.id))]


    Repo.all(Task)
    |> Enum.filter(&(Enum.member?(underlings_ids, &1.assigned_id)))
    |> Repo.preload(:user)
    |> Repo.preload(:assigned)
  end

  def get_managers(user) do
    user = Repo.preload(user, :underlings)
    manager_ids = Enum.map(user.underlings, &(&1.id))

    Repo.all(User)
    |> Enum.filter(&(Enum.member?(manager_ids, &1.id)))
  end

  def get_underlings(user) do
    user = Repo.preload(user, :managers)
    underlings_ids = Enum.map(user.managers, &(&1.id))

    Repo.all(User)
    |> Enum.filter(&(Enum.member?(underlings_ids, &1.id)))
  end


  @doc """
  Returns the list of blocks.

  ## Examples

      iex> list_blocks()
      [%TimeBlocks{}, ...]

  """
  def list_blocks do
    Repo.all(TimeBlock)
  end

  @doc """
  Gets a single time_block.

  Raises `Ecto.NoResultsError` if the Time block does not exist.

  ## Examples

      iex> get_time_block!(123)
      %TimeBlock{}

      iex> get_time_block!(456)
      ** (Ecto.NoResultsError)

  """
  def get_time_block!(id), do: Repo.get!(TimeBlock, id)

  @doc """
  Creates a time_block.

  ## Examples

      iex> create_time_block(%{field: value})
      {:ok, %TimeBlock{}}

      iex> create_time_block(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_time_block(attrs \\ %{}) do
    %TimeBlock{}
    |> TimeBlock.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a time_block.

  ## Examples

      iex> update_time_block(time_block, %{field: new_value})
      {:ok, %TimeBlock{}}

      iex> update_time_block(time_block, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_time_block(%TimeBlock{} = time_block, attrs) do
    time_block
    |> TimeBlock.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a TimeBlock.

  ## Examples

      iex> delete_time_block(time_block)
      {:ok, %TimeBlock{}}

      iex> delete_time_block(time_block)
      {:error, %Ecto.Changeset{}}

  """
  def delete_time_block(%TimeBlock{} = time_block) do
    Repo.delete(time_block)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking time_block changes.

  ## Examples

      iex> change_time_block(time_block)
      %Ecto.Changeset{source: %TimeBlock{}}

  """
  def change_time_block(%TimeBlock{} = time_block) do
    TimeBlocks.changeset(time_block, %{})
  end

  def get_time_blocks_by_task_id(task_id) do
    Repo.all(from b in TimeBlock,
             where: b.task_id == ^task_id)
    |> Enum.map(&(%{"id": &1.id,
                    "start": NaiveDateTime.truncate(&1.start, :second),
                    "end": NaiveDateTime.truncate(&1.end, :second)}))
  end
end
